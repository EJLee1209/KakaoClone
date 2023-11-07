//
//  ChatService.swift
//  KakaoClone
//
//  Created by 이은재 on 11/4/23.
//

import Foundation
import RxSwift
import Alamofire

final class ChatService: APIServiceType {
    // 채팅방 생성
    func createChatRoom(userIds: [String]) -> Observable<ChatRoom> {
        return Observable<ChatRoom>.create { observer in
            AF.request(APIType.createRoom(userIds: userIds))
                .responseData(completionHandler: self.responseCompletion(observer: observer))
            return Disposables.create()
        }
    }
    // 채팅방 입장
    func joinChatRoom(userId: String, roomId: Int) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            AF.request(APIType.joinRoom(userId: userId, chatRoomId: roomId))
                .responseData(completionHandler: self.responseCompletion(observer: observer))
            return Disposables.create()
        }
    }
    // 채팅방 퇴장
    func exitChatRoom(userId: String, roomId: Int) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            AF.request(APIType.exitRoom(userId: userId, chatRoomId: roomId))
                .responseData(completionHandler: self.responseCompletion(observer: observer))
            return Disposables.create()
        }
    }
    
    // 특정 사용자와의 1대1 채팅방 조회
    func fetchOneToOneRoom(firstUserId: String, secondUserId: String) -> Observable<ChatRoom> {
        return Observable<ChatRoom>.create { observer in
            AF.request(APIType.fetchOneToOneRoom(firstUserId: firstUserId, secondUserId: secondUserId))
                .responseData(completionHandler: self.responseCompletion(observer: observer))
            return Disposables.create()
        }
    }
    // 메시지 조회
    func fetchMessages(roomId: Int) -> Observable<[ChatMessage]> {
        return Observable<[ChatMessage]>.create { observer in
            AF.request(APIType.fetchMessages(chatRoomId: roomId))
                .responseData(completionHandler: self.responseCompletion(observer: observer))
            return Disposables.create()
        }
    }
    // 채팅방에 참여하고 있는 유저 목록 조회
    func fetchChatRoomUsers(roomId: Int) -> Observable<[User]> {
        return Observable<[User]>.create { observer in
            AF.request(APIType.fetchRoomUsers(chatRoomId: roomId))
                .responseData(completionHandler: self.responseCompletion(observer: observer))
            return Disposables.create()
        }
    }
}

