//
//  FriendDetailViewModel.swift
//  KakaoClone
//
//  Created by 이은재 on 10/28/23.
//

import Foundation

final class FriendDetailViewModel {
    
    let user: User
    var selectedFriend: User?
    
    init(user: User, selectedFriend: User?) {
        self.user = user
        self.selectedFriend = selectedFriend
    }
    
}
