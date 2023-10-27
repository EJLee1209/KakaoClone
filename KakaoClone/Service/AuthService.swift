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
    
    func signIn(
        id: String,
        password: String
    ) -> Observable<AuthResponse> {
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        
        return Observable<AuthResponse>.create { observer in
            let request = AF.request(
                Constants.signInEndPoint,
                method: .post,
                parameters: ["id": id, "password": password],
                encoding: JSONEncoding.default,
                headers: header
            ).responseData(completionHandler: self.authCompletion(observer: observer))
            
            return Disposables.create {
                request.cancel() // Observable이 dispose될 때, 요청 취소
            }
        }
    }

    func signUp(
        user: User,
        image: UIImage?
    ) -> Observable<AuthResponse> {
        let header: HTTPHeaders = ["Content-Type": "multipart/form-data"]
        
        return Observable<AuthResponse>.create { observer in
            let request = AF.upload(multipartFormData: { multipartFromData in
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
                .responseData(completionHandler: self.authCompletion(observer: observer))
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func authCompletion(observer: AnyObserver<AuthResponse>) -> ((AFDataResponse<Data>) -> Void) {
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
                let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                if statusCode == 200 {
                    observer.onNext(authResponse)
                } else {
                    observer.onError(APIError.requestFailed(description: authResponse.message))
                }
            } catch {
                observer.onError(APIError.jsonParsingFailure)
            }
        }
    }
}
