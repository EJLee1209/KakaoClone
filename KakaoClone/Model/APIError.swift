//
//  APIError.swift
//  KakaoClone
//
//  Created by 이은재 on 10/26/23.
//

import Foundation

enum APIError: Error {
    case invalidData
    case jsonParsingFailure
    case requestFailed(description: String)
    case invalidStatusCode(statusCode: Int)
    case unknownError(error: Error)
    
    var customDescription: String {
        switch self {
        case .invalidData: return "Invalid Data: 데이터가 유효하지 않습니다"
        case .jsonParsingFailure: return "Failed to Json Decoding: JSON 디코딩 에러"
        case let .requestFailed(description): return "Request Failed: \(description)"
        case let .invalidStatusCode(statusCode): return "Invalid status code: \(statusCode)"
        case let .unknownError(error): return "Unknown Error: \(error.localizedDescription)"
        }
    }
}
