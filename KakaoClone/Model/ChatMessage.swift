//
//  Message.swift
//  KakaoClone
//
//  Created by 이은재 on 11/2/23.
//

import Foundation

struct ChatMessage: Codable {
    let id: Int
    let roomId: Int
    let senderId: String
    let message: String?
    let imagePath: [String]?
    var timestamp: Date = Date()
    
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
    
    
    static let mockDataSource: [ChatMessage] = [
        .init(id: 0, roomId: 0, senderId: "suzylove", message: "안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요", imagePath: nil),
        .init(id: 1, roomId: 0, senderId: "dldmswo1209", message: "안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕", imagePath: nil),
        .init(id: 2, roomId: 0, senderId: "sonny", message: nil, imagePath: [
            "\(Constants.baseURL)/images/image-1698484500316.png",
        ]),
        .init(id: 2, roomId: 0, senderId: "sonny", message: nil, imagePath: [
            "\(Constants.baseURL)/images/image-1698484500316.png",
            "\(Constants.baseURL)/images/image-1698484500316.png",
            "\(Constants.baseURL)/images/image-1698484500316.png",
            "\(Constants.baseURL)/images/image-1698484500316.png",
            "\(Constants.baseURL)/images/image-1698484500316.png",
            "\(Constants.baseURL)/images/image-1698484500316.png",
            "\(Constants.baseURL)/images/image-1698484500316.png"
        ]),
        .init(id: 3, roomId: 0, senderId: "dldmswo1209", message: "우와 월클 손흥민!", imagePath: nil),
        .init(id: 4, roomId: 0, senderId: "suzylove", message: "어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...", imagePath: nil),
        .init(id: 6, roomId: 0, senderId: "dldmswo1209", message: nil, imagePath: [
            "\(Constants.baseURL)/images/image-1698734600855.png",
            "\(Constants.baseURL)/images/image-1698576086660.png",
            "\(Constants.baseURL)/images/image-1698484467680.png",
            "\(Constants.baseURL)/images/image-1698576205201.png",
            "\(Constants.baseURL)/images/image-1698416125741.png",
            "\(Constants.baseURL)/images/image-1698408236446.png",
            "\(Constants.baseURL)/images/image-1698484500316.png"
        ]),
        .init(id: 7, roomId: 0, senderId: "joker", message: nil, imagePath: [
            "\(Constants.baseURL)/images/image-1698734600855.png",
            "\(Constants.baseURL)/images/image-1698576086660.png",
            "\(Constants.baseURL)/images/image-1698484467680.png",
            "\(Constants.baseURL)/images/image-1698576205201.png",
            "\(Constants.baseURL)/images/image-1698416125741.png",
            "\(Constants.baseURL)/images/image-1698408236446.png",
            "\(Constants.baseURL)/images/image-1698484500316.png"
        ]),
        .init(id: 8, roomId: 0, senderId: "sonny", message: nil, imagePath: [
            "\(Constants.baseURL)/images/image-1698734600855.png",
            "\(Constants.baseURL)/images/image-1698576086660.png",
            "\(Constants.baseURL)/images/image-1698484467680.png",
            "\(Constants.baseURL)/images/image-1698576205201.png",
            "\(Constants.baseURL)/images/image-1698416125741.png",
            "\(Constants.baseURL)/images/image-1698408236446.png",
            "\(Constants.baseURL)/images/image-1698484500316.png"
        ]),
        .init(id: 9, roomId: 0, senderId: "suzylove", message: nil, imagePath: [
            "\(Constants.baseURL)/images/image-1698734600855.png",
            "\(Constants.baseURL)/images/image-1698576086660.png",
            "\(Constants.baseURL)/images/image-1698484467680.png",
            "\(Constants.baseURL)/images/image-1698576205201.png",
            "\(Constants.baseURL)/images/image-1698416125741.png",
            "\(Constants.baseURL)/images/image-1698408236446.png",
            "\(Constants.baseURL)/images/image-1698484500316.png"
        ]),
    ]
}
