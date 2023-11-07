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
    
    case createRoom(userIds: [String])
    case joinRoom(userId: String, chatRoomId: Int)
    case exitRoom(userId: String, chatRoomId: Int)
    case fetchOneToOneRoom(firstUserId: String, secondUserId: String)
    case fetchMessages(chatRoomId: Int)
    case fetchRoomUsers(chatRoomId: Int)
//    case fetchRooms(userId: String)

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
        case .createRoom:
            return "/chat/room/create"
        case .joinRoom:
            return "/chat/room/join"
        case .exitRoom:
            return "/chat/room/exit"
        case let .fetchOneToOneRoom(firstUserId, secondUserId):
            return "/chat/room/one?userId1=\(firstUserId)&userId2=\(secondUserId)"
        case let .fetchMessages(chatRoomId):
            return "/chat?chatRoomId=\(chatRoomId)"
        case let .fetchRoomUsers(chatRoomId):
            return "/chat/room/users?chatRoomId=\(chatRoomId)"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .deleteFriend,.addFriend, .signUp, .signIn, .createRoom, .joinRoom, .exitRoom:
            return .post
        case .fetchFriends, .fetchUser, .fetchOneToOneRoom, .fetchRoomUsers, .fetchMessages:
            return .get
        case .updateProfile:
            return .put
        
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .deleteFriend, .addFriend, .fetchUser, .fetchFriends, .signIn, .createRoom, .joinRoom, .exitRoom, .fetchOneToOneRoom, .fetchMessages, .fetchRoomUsers:
            return ["Content-Type": "application/json"]
        case .signUp, .updateProfile:
            return ["Content-Type": "multipart/form-data"]
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .fetchFriends, .fetchUser, .signUp, .updateProfile, .fetchOneToOneRoom, .fetchRoomUsers, .fetchMessages:
            return nil
        case let .createRoom(userIds):
            return ["userIds" : userIds]
        case let .deleteFriend(fromId, toId), let .addFriend(fromId, toId):
            return ["from_id": fromId, "to_id": toId]
        case let .signIn(id, password):
            return ["id": id, "password": password]
        case let .joinRoom(userId, chatRoomId), let .exitRoom(userId,chatRoomId):
            return ["userId": userId, "chatRoomId": chatRoomId]
        }
    }
    
    var encoding: Alamofire.ParameterEncoding? {
        return JSONEncoding.default
    }
    
    func asURLRequest() throws -> URLRequest {
        print("DEBUG request url: \(baseURL + path)")
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
            multipartFormData.append(Data(user.password?.utf8 ?? "".utf8), withName: "password")
            
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
