//
//  Message.swift
//  KakaoClone
//
//  Created by 이은재 on 11/2/23.
//

import Foundation
import SocketIO



struct ChatMessage: SocketData, Codable {
    let id: Int
    let chatRoomId: Int
    let senderId: String
    let message: String?
    let imagePath: [String]?
    var timestamp: String
    
    var uuid: String? = UUID().uuidString
    var isSent: Bool? = true
    
    func socketRepresentation() throws -> SocketData {
        return [
            "uuid": uuid ?? "",
            "id": id,
            "chatRoomId": chatRoomId,
            "senderId": senderId,
            "message": message ?? "",
            "imagePath": imagePath ?? [],
            "timestamp": timestamp
        ]
    }
    enum MessageType {
        case image
        case text
    }
    
    var type: MessageType {
        guard let _ = imagePath else {
            return .text
        }
        return .image
    }
    
    var images: [URL?] {
        guard let imagePath = imagePath else { return [] }
        return imagePath.map { URL(string: $0) }
    }
    
    func isMine(currentUser: User) -> Bool {
        return currentUser.id == senderId
    }
    
    
}
