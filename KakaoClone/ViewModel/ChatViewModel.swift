//
//  ChatViewModel.swift
//  KakaoClone
//
//  Created by 이은재 on 10/31/23.
//



import Foundation
import RxSwift
import RxRelay

final class ChatViewModel {
    
    let user: User // 본인
    var friends: [User] = [] // 대화 상대
    private var chatType: ChatType
    
    private let chatService: ChatService = .init()
    private let socketService: SocketService = .init()
    private let bag = DisposeBag()
    
    var dataSource: [ChatMessage] = [] {
        didSet {
            updateDataSource()
        }
    }
    var updateDataSource: () -> Void = {}
    
    
    var roomId: Int = -1
    
    init(
        user: User,
        selectedUser: User?,
        chatType: ChatType
    ) {
        self.user = user
        self.chatType = chatType
        
        if let selectedUser = selectedUser {
            friends.append(selectedUser)
        }
        
        socketService.socketConnected
            .bind { [weak self] isConnected in
                if isConnected {
                    switch chatType {
                    case .oneToOne:
                        self?.fetchOneToOneRoom()
                    case .groupChat:
                        break
                    }
                }
            }.disposed(by: bag)

        socketService.message
            .bind { [weak self] message in
                print("DEBUG new Message!! : \(message)")
                self?.dataSource.append(message)
            }.disposed(by: bag)
        
        socketService.myMessage
            .bind { [weak self] message in
                if message.id == -1 {
                    self?.dataSource.append(message)
                } else {
                    guard let index = self?.dataSource.firstIndex(where: { $0.uuid == message.uuid }) else { return }
                    var newMessage = message
                    newMessage.isSent = true
                    self?.dataSource[index] = newMessage
                }
            }.disposed(by: bag)
    }
    
    func sendMessage(_ message: String) {
        if roomId != -1 {
            socketService.sendMessage(senderId: user.id, message: message)
        } else {
            
            chatService.createChatRoom(userIds: [user.id] + friends.map{ $0.id }) // 채팅방 생성
                .map { $0.id }
                .bind { [weak self] roomId in
                    self?.roomId = roomId
                    self?.socketService.joinRoom(roomId: roomId)
                    self?.sendMessage(message)
                }.disposed(by: bag)
        }
    }
    
    func fetchOneToOneRoom() {
        guard let friend = friends.first else { return }
        chatService.fetchOneToOneRoom(firstUserId: user.id, secondUserId: friend.id)
            .map { $0.id }
            .bind { [weak self] roomId in
                self?.roomId = roomId
                if roomId != -1 { // 채팅방이 존재
                    self?.socketService.joinRoom(roomId: roomId)
                    self?.fetchMessages(roomId: roomId)
                }
            }.disposed(by: bag)
    }
    
    private func fetchMessages(roomId: Int) {
        chatService.fetchMessages(roomId: roomId)
            .bind { [weak self] messages in
                self?.dataSource = messages
            }.disposed(by: bag)
    }
}
