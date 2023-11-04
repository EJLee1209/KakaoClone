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
    
    func deleteFriend(fromId: String, toId: String) -> Observable<Bool> {
        return Observable<Bool>.create { observer -> Disposable in
            AF.request(APIType.deleteFriend(fromId: fromId, toId: toId))
                .responseData(completionHandler: self.authCompletion(observer: observer))
            return Disposables.create()
        }
    }
    
    func addFriend(fromId: String, toId: String) -> Observable<Bool> {
        return Observable<Bool>.create { observer -> Disposable in
            AF.request(APIType.addFriend(fromId: fromId, toId: toId))
                .responseData(completionHandler: self.authCompletion(observer: observer))
            return Disposables.create()
        }
    }
    
    func fetchFriends(id: String) -> Observable<FriendsResponse> {
        return Observable<FriendsResponse>.create { observer -> Disposable in
            AF.request(APIType.fetchFriends(id: id))
                .responseData(completionHandler: self.authCompletion(observer: observer))
            return Disposables.create()
        }
    }
    
    func fetchUser(id: String) -> Observable<AuthResponse> {
        return Observable<AuthResponse>.create { observer -> Disposable in
            AF.request(APIType.fetchUser(id: id))
                .responseData(completionHandler: self.authCompletion(observer: observer))
            return Disposables.create()
        }
    }
    
    func signIn(
        id: String,
        password: String
    ) -> Observable<AuthResponse> {
        return Observable<AuthResponse>.create { observer in
            AF.request(APIType.signIn(id: id, password: password))
                .responseData(completionHandler: self.authCompletion(observer: observer))
            return Disposables.create()
        }
    }
    
    func updateProfile(
        user: User,
        selectedImage: UIImage?
    ) -> Observable<AuthResponse> {
        let api: APIType = .updateProfile(user: user, selectedImage: selectedImage)
        
        return Observable<AuthResponse>.create { observer in
            AF.upload(multipartFormData: api.multipartData(_:), with: api)
                .responseData(completionHandler: self.authCompletion(observer: observer))
            return Disposables.create()
        }
    }

    func signUp(
        user: User,
        image: UIImage?
    ) -> Observable<AuthResponse> {
        let api: APIType = .signUp(user: user, image: image)
        
        return Observable<AuthResponse>.create { observer in
            AF.upload(multipartFormData: api.multipartData(_:), with: api)
                .responseData(completionHandler: self.authCompletion(observer: observer))
            return Disposables.create()
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
