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
    
    struct Input {
        
    }
    
    struct Ouput {
        
    }
    
    init(user: User) {
        self.user = user
        self.dataSource = [
            .userProfileSection(user: user),
            .friendsSection(users: [])
        ]
    }
    
}
