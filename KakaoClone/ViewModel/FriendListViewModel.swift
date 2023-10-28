//
//  FriendListViewModel.swift
//  KakaoClone
//
//  Created by 이은재 on 10/27/23.
//

import Foundation
import RxSwift



final class FriendListViewModel {
    
    let user: User
    let dataSource: [FriendListSection]
    let authService: AuthService
    
    
    init(user: User, authService: AuthService) {
        self.user = user
        self.authService = authService
        self.dataSource = [
            .userProfileSection(user: user),
            .friendsSection(users: [])
        ]
    }
}
