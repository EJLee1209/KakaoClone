//
//  MainViewModel.swift
//  KakaoClone
//
//  Created by 이은재 on 10/27/23.
//

import Foundation
import RxSwift
import UIKit

final class MainViewModel {
    
    let authService: AuthService
    var user: User?
    private let bag = DisposeBag()
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func checkLogin() -> LoginViewModel? {
        guard let loginID = UserDefaults.standard.string(forKey: "loginID") else {
            // 로그인 필요
            return LoginViewModel(authService: authService)
        }
        // 서버에 User 데이터 요청
        authService.fetchUser(id: loginID)
            .subscribe { response in
                print("DEBUG fetchUser successfully: \(response)")
            } onError: { error in
                print("DEBUG fetchUser error: \(error)")
            }.disposed(by: bag)

        return nil
    }
    
}
