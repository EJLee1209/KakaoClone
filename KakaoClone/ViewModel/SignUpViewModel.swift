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
        var apiStateObservable: Observable<APIState>
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
            apiStateObservable: self.state.skip(1).asObservable()
        )
    }
    
    func requestRegistration() {
        state.accept(.loading)
        let user = User(id: id, name: name, password: password)
        
        authService.signup(user: user, image: profileImage) { [weak self] result in
            switch result {
            case .success(let response):
                self?.state.accept(.success(response.message))
            case .failure(let error):
                self?.state.accept(.failed(error.customDescription))
            }
        }
    }
}
