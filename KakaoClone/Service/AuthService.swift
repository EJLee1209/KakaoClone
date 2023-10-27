//
//  AuthService.swift
//  KakaoClone
//
//  Created by 이은재 on 10/26/23.
//

import RxSwift
import UIKit
import Alamofire

final class AuthService {
    typealias AuthCompletionHandlerType = (Result<AuthResponse, APIError>) -> Void
    
    func signIn(
        id: String,
        password: String,
        completion: @escaping AuthCompletionHandlerType
    ) {
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        AF.request(
            Constants.signInEndPoint,
            method: .post,
            parameters: ["id": id, "password": password],
            encoding: JSONEncoding.default,
            headers: header
        )
        .responseData { dataResponse in
            guard let statusCode = dataResponse.response?.statusCode else {
                completion(.failure(.requestFailed(description: "서버 요청 실패")))
                return
            }
                
            guard let data = dataResponse.data else {
                completion(.failure(.invalidData))
                return
            }
                
            switch statusCode {
            case 200, 400, 500:
                do {
                    let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                    if statusCode == 200 {
                        completion(.success(authResponse))
                    } else {
                        completion(.failure(.requestFailed(description: authResponse.message)))
                    }
                } catch {
                    completion(.failure(.unknownError(error: error)))
                }
            default:
                completion(.failure(.invalidStatusCode(statusCode: statusCode)))
                return
            }
        }
    }
    
    func signUp(
        user: User,
        image: UIImage?,
        completion: @escaping AuthCompletionHandlerType
    ) {
        let header: HTTPHeaders = ["Content-Type": "multipart/form-data"]
        
        AF.upload(multipartFormData: { multipartFromData in
            multipartFromData.append(Data(user.id.utf8), withName: "id")
            multipartFromData.append(Data(user.name.utf8), withName: "name")
            multipartFromData.append(Data(user.password.utf8), withName: "password")
            
            if let image {
                multipartFromData.append(
                    image.pngData() ?? Data(),
                    withName: "image",
                    fileName: "image/png",
                    mimeType: "image/png"
                )
            }
            
        }, to: Constants.signUpEndPoint, method: .post, headers: header)
        .responseData { response in
            guard let statusCode = response.response?.statusCode else {
                completion(.failure(.requestFailed(description: "서버 요청 실패")))
                return
            }
            
            guard let data = response.data else {
                completion(.failure(.invalidData))
                return
            }
            
            switch statusCode {
            case 200, 400, 500:
                do {
                    let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                    if statusCode == 200 {
                        completion(.success(authResponse))
                    } else {
                        completion(.failure(.requestFailed(description: authResponse.message)))
                    }
                } catch {
                    completion(.failure(.unknownError(error: error)))
                }
            default:
                completion(.failure(.invalidStatusCode(statusCode: statusCode)))
                return
            }
        }
    }
}
