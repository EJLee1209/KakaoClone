//
//  Constants.swift
//  KakaoClone
//
//  Created by 이은재 on 10/26/23.
//

import Foundation

final class Constants {
    static let baseURL = "http://localhost:8080"
    static let signUpEndPoint = "\(baseURL)/register"
    static let signInEndPoint = "\(baseURL)/login"
    static let fetchUserEndPoint = "\(baseURL)/user?id="
    static let addFriendEndPoint = "\(baseURL)/friends/add"
    static let fetchFrinedsEndPoint = "\(baseURL)/friends/list?id="
    static let deleteFriendEndPoint = "\(baseURL)/friends/delete"
}
