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
    
    func checkLogin(completion: @escaping (LoginViewModel?) -> Void) {
        guard let loginID = UserDefaults.standard.string(forKey: "loginID") else {
            // 로그인 필요
            completion(makeLoginViewModel())
            return
        }
        // 서버에 User 데이터 요청
        authService.fetchUser(id: loginID)
            .subscribe { [weak self] response in
                self?.user = response.data
                completion(nil)
            } onError: { error in
                print("DEBUG fetchUser error: \(error)")
                completion(nil)
            }.disposed(by: bag)
    }
    
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(authService: authService)
    }
    
}
