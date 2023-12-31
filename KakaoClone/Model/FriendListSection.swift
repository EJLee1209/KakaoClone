//
//  FriendListSection.swift
//  KakaoClone
//
//  Created by 이은재 on 10/27/23.
//

import Foundation

enum FriendListSection {
    case userProfileSection(user: User)
    case friendsSection(users: [User])
}
