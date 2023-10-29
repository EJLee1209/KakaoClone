//
//  FriendDetailViewModel.swift
//  KakaoClone
//
//  Created by 이은재 on 10/28/23.
//

import Foundation
import UIKit


final class FriendDetailViewModel {
    
    var user: User
    var selectedFriend: User?
    var selectedProfileImage: UIImage?
    
    
    init(user: User, selectedFriend: User?) {
        self.user = user
        self.selectedFriend = selectedFriend
    }
    
}
