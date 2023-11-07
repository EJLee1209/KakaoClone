//
//  AuthService.swift
//  KakaoClone
//
//  Created by 이은재 on 10/26/23.
//

import RxSwift
import UIKit
import Alamofire



final class AuthService: APIServiceType {
    
    func deleteFriend(fromId: String, toId: String) -> Observable<Bool> {
        return Observable<Bool>.create { observer -> Disposable in
            AF.request(APIType.deleteFriend(fromId: fromId, toId: toId))
                .responseData(completionHandler: self.responseCompletion(observer: observer))
            return Disposables.create()
        }
    }
    
    func addFriend(fromId: String, toId: String) -> Observable<Bool> {
        return Observable<Bool>.create { observer -> Disposable in
            AF.request(APIType.addFriend(fromId: fromId, toId: toId))
                .responseData(completionHandler: self.responseCompletion(observer: observer))
            return Disposables.create()
        }
    }
    
    func fetchFriends(id: String) -> Observable<FriendsResponse> {
        return Observable<FriendsResponse>.create { observer -> Disposable in
            AF.request(APIType.fetchFriends(id: id))
                .responseData(completionHandler: self.responseCompletion(observer: observer))
            return Disposables.create()
        }
    }
    
    func fetchUser(id: String) -> Observable<AuthResponse> {
        return Observable<AuthResponse>.create { observer -> Disposable in
            AF.request(APIType.fetchUser(id: id))
                .responseData(completionHandler: self.responseCompletion(observer: observer))
            return Disposables.create()
        }
    }
    
    func signIn(
        id: String,
        password: String
    ) -> Observable<AuthResponse> {
        return Observable<AuthResponse>.create { observer in
            AF.request(APIType.signIn(id: id, password: password))
                .responseData(completionHandler: self.responseCompletion(observer: observer))
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
                .responseData(completionHandler: self.responseCompletion(observer: observer))
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
                .responseData(completionHandler: self.responseCompletion(observer: observer))
            return Disposables.create()
        }
    }
    
    
}
