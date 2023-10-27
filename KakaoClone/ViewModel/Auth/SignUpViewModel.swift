//
//  RegistrationViewModel.swift
//  KakaoClone
//
//  Created by 이은재 on 10/26/23.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

final class SignUpViewModel {
    //MARK: - Properties
    private let bag = DisposeBag()
    
    private var id: String = ""
    private var name: String = ""
    private var password: String = ""
    var profileImage: UIImage?
    
    private var state: BehaviorRelay<APIState> = .init(value: .none)
    
    let authService: AuthService
    init(authService: AuthService) {
        self.authService = authService
    }
    
    //MARK: - Input
    struct Input {
        var idObservable: ControlProperty<String?>
        var nameObservable: ControlProperty<String?>
        var passwordObservable: ControlProperty<String?>
        var passwordConfirmObservable: ControlProperty<String?>
        var registerButtonTap: ControlEvent<Void>
    }
    
    //MARK: - Output
    struct Output {
        var registerButtonEnabled: Observable<Bool>
        var passwordValidation: Observable<Bool>
        var signUpStateObservable: Observable<APIState>
    }
    
    //MARK: - Helpers
    func transform(input: Input) -> Output {
        // 비밀번호 유효성 검사
        let passwordValidation = Observable.combineLatest(
            input.passwordObservable,
            input.passwordConfirmObservable
        ).flatMapLatest { [weak self] (password, passwordConfirm) in
            guard let password = password, let confirm = passwordConfirm else {
                return Observable.just(false)
            }
            self?.password = password
            
            return Observable.just(password.count >= 8 && password.count <= 32 && password == confirm)
        }.asObservable()

        // 회원가입 버튼 활성/비활성
        let registerButtonEnabled = Observable.combineLatest(
            input.idObservable,
            input.nameObservable,
            passwordValidation
        ).flatMap { [weak self] (id, name, passwordValidation) in
            guard let id = id, let name = name else { return Observable.just(false) }
            self?.id = id
            self?.name = name
                
            return Observable.just(!id.isEmpty && !name.isEmpty && passwordValidation)
        }.asObservable()
        
        return Output(
            registerButtonEnabled: registerButtonEnabled,
            passwordValidation: passwordValidation,
            signUpStateObservable: self.state.skip(1).asObservable()
        )
    }
    
    func requestRegistration() {
        state.accept(.loading)
        let user = User(id: id, name: name, password: password)
        
        authService.signUp(user: user, image: profileImage)
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
}
