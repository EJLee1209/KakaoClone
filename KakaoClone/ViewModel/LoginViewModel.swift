//
//  LoginViewModel.swift
//  KakaoClone
//
//  Created by 이은재 on 10/26/23.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewModel {
    private let bag = DisposeBag()
    
    //MARK: - Input
    struct Input {
        var idObservable: ControlProperty<String?>
        var passwordObservable: ControlProperty<String?>
        var loginTap: ControlEvent<Void>
    }
    
    //MARK: - Output
    struct Output {
        var loginButtonEnabled: Observable<Bool>
        var passwordFormatLabelIsHidden: Observable<Bool>
    }
    
    
    func transform(input: Input) -> Output {
        // 로그인 버튼 활성/비활성
        let loginButtonEnabledObservable = Observable.combineLatest(
            input.idObservable,
            input.passwordObservable
        ).flatMap { (id, password) in
            guard let id = id, let password = password else { 
                return Observable.just(false)
            }
            return Observable.just(!id.isEmpty && password.count >= 8 && password.count <= 32)
        }.asObservable()
        
        // 패스워드 형식 안내 메세지 hidden
        let passwordFormatLabelIsHiddenObservable = input.passwordObservable
            .flatMap { password in
                guard let password = password else { return Observable.just(false) }
                return Observable.just(password.count >= 8 && password.count <= 32)
            }.asObservable()
        
        return Output(
            loginButtonEnabled: loginButtonEnabledObservable,
            passwordFormatLabelIsHidden: passwordFormatLabelIsHiddenObservable
        )
    }
}
