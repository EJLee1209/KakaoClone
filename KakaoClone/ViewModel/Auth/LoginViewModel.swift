//
//  LoginViewModel.swift
//  KakaoClone
//
//  Created by 이은재 on 10/26/23.
//

import UIKit
import RxSwift
import RxRelay

final class LoginViewModel {
    private let bag = DisposeBag()
    private var id = ""
    private var password = ""
    
    private let authService: AuthService
    
    private var state: BehaviorRelay<APIState> = .init(value: .none)
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    //MARK: - Input
    struct Input {
        let idObservable: Observable<String?>
        let passwordObservable: Observable<String?>
        let loginTap: Observable<Void>
    }
    
    //MARK: - Output
    struct Output {
        let loginButtonEnabled: Observable<Bool>
        let passwordFormatLabelIsHidden: Observable<Bool>
        var signInStateObservable: Observable<APIState>
    }
    
    
    func transform(input: Input) -> Output {
        // 로그인 버튼 활성/비활성
        let loginButtonEnabledObservable = Observable.combineLatest(
            input.idObservable,
            input.passwordObservable
        ).flatMap { [weak self] (id, password) in
            guard let id = id, let password = password else {
                return Observable.just(false)
            }
            self?.id = id
            self?.password = password
            return Observable.just(!id.isEmpty && password.count >= 8 && password.count <= 32)
        }.asObservable()
        
        // 패스워드 형식 안내 메세지 hidden
        let passwordFormatLabelIsHiddenObservable = input.passwordObservable
            .flatMap { password in
                guard let password = password else { return Observable.just(false) }
                return Observable.just(password.count >= 8 && password.count <= 32)
            }.asObservable()
        
        // 로그인 버튼 탭
        input.loginTap
            .bind { [weak self] _ in
                self?.requestSignIn()
            }.disposed(by: bag)
        
        return Output(
            loginButtonEnabled: loginButtonEnabledObservable,
            passwordFormatLabelIsHidden: passwordFormatLabelIsHiddenObservable,
            signInStateObservable: state.skip(1).asObservable()
        )
    }
    
    private func requestSignIn() {
        state.accept(.loading)
        
        authService.signIn(id: id, password: password)
            .subscribe { [weak self] response in
                self?.state.accept(.success(response))
            } onError: { [weak self] error in
                if let apiError = error as? APIError {
                    self?.state.accept(.failed(apiError.customDescription))
                } else{
                    self?.state.accept(.failed("알 수 없는 오류가 발생했습니다"))
                }
            }.disposed(by: bag)
    }
    
    func makeSignUpViewModel() -> SignUpViewModel {
        return SignUpViewModel(authService: self.authService)
    }
}
