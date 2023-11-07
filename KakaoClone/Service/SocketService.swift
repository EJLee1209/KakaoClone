//
//  SocketService.swift
//  KakaoClone
//
//  Created by 이은재 on 11/5/23.
//

import Foundation
import SocketIO
import RxSwift
import RxRelay

final class SocketService {
    private let manager: SocketManager
    private let socket: SocketIOClient
    
    let message: PublishRelay<ChatMessage> = .init()
    let myMessage: PublishRelay<ChatMessage> = .init()
    let socketConnected: BehaviorRelay<Bool> = .init(value: false)
    
    init() {
        let url = URL(string: Constants.baseURL)!
        self.manager = .init(socketURL: url, config: [.log(true), .compress])
        self.socket = manager.defaultSocket
        
        self.socket.connect()
        addSocketEventHandler()
    }
    private func addSocketEventHandler() {
        // 소켓 연결 이벤트 핸들러
        socket.on(clientEvent: .connect) { [weak self] data, ack in
            print("DEBUG: socket connected")
            self?.socketConnected.accept(true)
        }
        // 소켓 연결 해제 이벤트 핸들러
        socket.on(clientEvent: .disconnect) { [weak self] data, ack in
            print("DEBUG: socket disconnected")
            self?.socketConnected.accept(false)
        }
        
        // 메시지 이벤트 핸들러
        socket.on("newMessage") { [weak self] data, ack in
            do {
                guard let data = data.first else { return }
                let jsonData = try JSONSerialization.data(withJSONObject: data)
                let chatMessage = try JSONDecoder().decode(ChatMessage.self, from: jsonData)
                self?.message.accept(chatMessage)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        socket.on("savedMessageSuccessfully") { [weak self] data, ack in
            do {
                guard let data = data.first else { return }
                let jsonData = try JSONSerialization.data(withJSONObject: data)
                var chatMessage = try JSONDecoder().decode(ChatMessage.self, from: jsonData)
                self?.myMessage.accept(chatMessage)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // 채팅방 입장
    func joinRoom(roomId: Int) {
        socket.emit("joinRoom", roomId)
    }
    
    // 메세지 전송
    func sendMessage(senderId: String, message: String) {
        let newMessage = ChatMessage(id: -1, chatRoomId: -1, senderId: senderId, message: message, imagePath: nil, timestamp: "", isSent: false)
        self.myMessage.accept(newMessage)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.socket.emit("sendMessage", newMessage)
        }
        
    }
}
