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
    
    func deleteFriend(from_id: String, to_id: String) -> Observable<Bool> {
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        
        return Observable<Bool>.create { observer in
            let request = AF.request(
                Constants.deleteFriendEndPoint,
                method: .post,
                parameters: ["from_id": from_id, "to_id": to_id],
                encoding: JSONEncoding.default,
                headers: header
            ).responseData(completionHandler: self.authCompletion(observer: observer))
            
            return Disposables.create {
                request.cancel() // Observable이 dispose될 때, 요청 취소
            }
        }
    }
    
    func addFriend(from_id: String, to_id: String) -> Observable<Bool> {
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        
        return Observable<Bool>.create { observer in
            let request = AF.request(
                Constants.addFriendEndPoint,
                method: .post,
                parameters: ["from_id": from_id, "to_id": to_id],
                encoding: JSONEncoding.default,
                headers: header
            ).responseData(completionHandler: self.authCompletion(observer: observer))
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func fetchFriends(id: String) -> Observable<FriendsResopnse> {
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        
        return Observable<FriendsResopnse>.create { observer in
            let request = AF.request(
                "\(Constants.fetchFrinedsEndPoint)\(id)",
                method: .get,
                encoding: JSONEncoding.default,
                headers: header
            ).responseData(completionHandler: self.authCompletion(observer: observer))
            
            return Disposables.create {
                request.cancel() // Observable이 dispose될 때, 요청 취소
            }
        }
    }
    
    func fetchUser(id: String) -> Observable<AuthResponse> {
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        
        return Observable<AuthResponse>.create { observer in
            let request = AF.request(
                "\(Constants.fetchUserEndPoint)\(id)",
                method: .get,
                encoding: JSONEncoding.default,
                headers: header
            ).responseData(completionHandler: self.authCompletion(observer: observer))
            
            return Disposables.create {
                request.cancel() // Observable이 dispose될 때, 요청 취소
            }
        }
    }
    
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
                request.cancel()
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
    
    func authCompletion<T: Codable>(observer: AnyObserver<T>) -> ((AFDataResponse<Data>) -> Void) {
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
                    if let response = response as? FriendsResopnse {
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
