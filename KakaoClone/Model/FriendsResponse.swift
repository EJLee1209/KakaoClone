//
//  Friends.swift
//  KakaoClone
//
//  Created by 이은재 on 10/28/23.
//

import Foundation

struct FriendsResponse: Codable {
    let status: Bool
    let message: String
    var data: [User]?
}
