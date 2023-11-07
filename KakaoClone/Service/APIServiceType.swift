//
//  APIService.swift
//  KakaoClone
//
//  Created by 이은재 on 11/5/23.
//

import Foundation
import RxSwift
import Alamofire

protocol APIServiceType {
    
}
extension APIServiceType {
    func responseCompletion<T: Codable>(observer: AnyObserver<T>) -> ((AFDataResponse<Data>) -> Void) {
        return { dataResponse in
            guard let statusCode = dataResponse.response?.statusCode else {
                observer.onError(APIError.requestFailed(description: "서버 요청 실패"))
                return
            }
                
            guard let data = dataResponse.data else {
                observer.onError(APIError.invalidData)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                if statusCode == 200 {
                    observer.onNext(response)
                } else {
                    if let response =  response as? AuthResponse {
                        observer.onError(APIError.requestFailed(description: response.message))
                        return
                    }
                    if let response = response as? FriendsResponse {
                        observer.onError(APIError.requestFailed(description: response.message))
                        return
                    }
                    observer.onError(APIError.invalidStatusCode(statusCode: statusCode))
                }
            } catch {
                observer.onError(APIError.jsonParsingFailure)
            }
        }
    }
}
