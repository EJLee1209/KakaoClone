//
//  APIType.swift
//  KakaoClone
//
//  Created by 이은재 on 11/4/23.
//

import Foundation
import Alamofire

enum APIType {
    case deleteFriend(fromId: String, toId: String)
    case addFriend(fromId: String, toId: String)
    case fetchFriends(id: String)
    case fetchUser(id: String)
    case signIn(id: String, password: String)
    case signUp(user: User, image: UIImage?)
    case updateProfile(user: User, selectedImage: UIImage?)
}

extension APIType: Router, URLRequestConvertible {
    var baseURL: String {
        return Constants.baseURL
    }
    
    var path: String {
        switch self {
        case .deleteFriend:
            return "/friends/delete"
        case .addFriend:
            return "/friends/add"
        case .fetchFriends(let id):
            return "/friends/list?id=\(id)"
        case .fetchUser(let id):
            return "/user?id=\(id)"
        case .signIn:
            return "/login"
        case .signUp:
            return "/register"
        case .updateProfile:
            return "/user/update"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .deleteFriend,.addFriend, .signUp, .signIn:
            return .post
        case .fetchFriends, .fetchUser:
            return .get
        case .updateProfile:
            return .put
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .deleteFriend, .addFriend, .fetchUser, .fetchFriends, .signIn:
            return ["Content-Type": "application/json"]
        case .signUp, .updateProfile:
            return ["Content-Type": "multipart/form-data"]
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case let .deleteFriend(fromId, toId), let .addFriend(fromId, toId):
            return ["from_id": fromId, "to_id": toId]
        case let .signIn(id, password):
            return ["id": id, "password": password]
        case .fetchFriends, .fetchUser, .signUp, .updateProfile:
            return nil
        }
    }
    
    var encoding: Alamofire.ParameterEncoding? {
        return JSONEncoding.default
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: baseURL + path)
        var request = URLRequest(url: url!)
        
        request.method = method
        request.headers = HTTPHeaders(headers)
        
        if let encoding = encoding {
            return try encoding.encode(request, with: parameters)
        }
        
        return request
    }
    
    func multipartData(_ multipartFormData: MultipartFormData) {
        switch self {
        case let .signUp(user, image):
            multipartFormData.append(Data(user.id.utf8), withName: "id")
            multipartFormData.append(Data(user.name.utf8), withName: "name")
            multipartFormData.append(Data(user.password.utf8), withName: "password")
            
            if let image {
                multipartFormData.append(
                    image.pngData() ?? Data(),
                    withName: "image",
                    fileName: "image/png",
                    mimeType: "image/png"
                )
            }
        case let .updateProfile(user, selectedImage):
            multipartFormData.append(Data(user.id.utf8), withName: "id")
            multipartFormData.append(Data(user.name.utf8), withName: "name")
            if let imagePath = user.imagePath {
                multipartFormData.append(Data(imagePath.utf8), withName: "originalImagePath")
            }
            multipartFormData.append(Data(user.stateMessage?.utf8 ?? "".utf8), withName: "stateMessage")
            if let selectedImage {
                multipartFormData.append(
                    selectedImage.pngData() ?? Data(),
                    withName: "image",
                    fileName: "image/png",
                    mimeType: "image/png"
                )
            }
        default:
            return
        }
    }
}
