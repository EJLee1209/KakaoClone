//
//  User.swift
//  KakaoClone
//
//  Created by 이은재 on 10/26/23.
//

import Foundation

struct User: Codable{
    let id: String
    var name: String
    let password: String?
    var imagePath: String?
    var stateMessage: String?
    
    var imageUrl: URL? {
        guard let imagePath = imagePath else { return nil }
        return URL(string: "\(Constants.baseURL)/\(imagePath)")
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case password
        case imagePath = "profile_image_path"
        case stateMessage = "state_message"
    }
}
