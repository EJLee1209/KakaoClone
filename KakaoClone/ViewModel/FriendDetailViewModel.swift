//
//  FriendDetailViewModel.swift
//  KakaoClone
//
//  Created by 이은재 on 10/28/23.
//

import UIKit
import RxSwift

final class FriendDetailViewModel {
    
    var user: User
    var selectedFriend: User?
    var selectedProfileImage: UIImage?
    let authService: AuthService
    private let bag = DisposeBag()
    
    init(user: User, selectedFriend: User?, authService: AuthService) {
        self.user = user
        self.selectedFriend = selectedFriend
        self.authService = authService
    }
    
    func updateUser() {
        authService.updateProfile(user: user, selectedImage: selectedProfileImage)
            .subscribe { response in
                print("DEBUG update profile response: \(response)")
            } onError: { error in
                print("DEBUG update profile error: \(error)")
            }.disposed(by: bag)
    }
}
