//
//  APIState.swift
//  KakaoClone
//
//  Created by 이은재 on 10/26/23.
//

import Foundation

enum APIState {
    case none
    case loading
    case success(Decodable)
    case failed(String)
}
