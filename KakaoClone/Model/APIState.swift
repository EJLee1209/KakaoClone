//
//  APIState.swift
//  KakaoClone
//
//  Created by 이은재 on 10/26/23.
//

import Foundation

enum APIState: Comparable {
    case none
    case loading
    case success(String)
    case failed(String)
}
