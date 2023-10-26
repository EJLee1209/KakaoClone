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
    let password: String
    var imagePath: String?
    
    var imageUrl: URL? {
        guard let imagePath = imagePath else { return nil }
        return URL(string: "\(Constants.baseURL)/\(imagePath)")
    }
}
