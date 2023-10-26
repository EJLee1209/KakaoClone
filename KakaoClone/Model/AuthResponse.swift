//
//  AuthResponse.swift
//  KakaoClone
//
//  Created by 이은재 on 10/26/23.
//

import Foundation

struct AuthResponse: Codable {
    let status: Bool
    let message: String
    let data: User?
}
