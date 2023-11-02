//
//  Message.swift
//  KakaoClone
//
//  Created by 이은재 on 11/2/23.
//

import Foundation

struct Message: Codable {
    let id: Int
    let roomId: Int
    let senderId: String
    let text: String?
    let imagePath: [String]?
    var dateTime: Date = Date()
    
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
    
    
    static let mockDataSource: [Message] = [
        .init(id: 0, roomId: 0, senderId: "suzylove", text: "안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요", imagePath: nil),
        .init(id: 1, roomId: 0, senderId: "dldmswo1209", text: "안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕안녕", imagePath: nil),
        .init(id: 2, roomId: 0, senderId: "sonny", text: nil, imagePath: [
            "\(Constants.baseURL)/images/image-1698484500316.png",
        ]),
        .init(id: 2, roomId: 0, senderId: "sonny", text: nil, imagePath: [
            "\(Constants.baseURL)/images/image-1698484500316.png",
            "\(Constants.baseURL)/images/image-1698484500316.png",
            "\(Constants.baseURL)/images/image-1698484500316.png",
            "\(Constants.baseURL)/images/image-1698484500316.png",
            "\(Constants.baseURL)/images/image-1698484500316.png",
            "\(Constants.baseURL)/images/image-1698484500316.png",
            "\(Constants.baseURL)/images/image-1698484500316.png"
        ]),
        .init(id: 3, roomId: 0, senderId: "dldmswo1209", text: "우와 월클 손흥민!", imagePath: nil),
        .init(id: 4, roomId: 0, senderId: "suzylove", text: "어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...어맛...", imagePath: nil),
        .init(id: 6, roomId: 0, senderId: "dldmswo1209", text: nil, imagePath: [
            "\(Constants.baseURL)/images/image-1698734600855.png",
            "\(Constants.baseURL)/images/image-1698576086660.png",
            "\(Constants.baseURL)/images/image-1698484467680.png",
            "\(Constants.baseURL)/images/image-1698576205201.png",
            "\(Constants.baseURL)/images/image-1698416125741.png",
            "\(Constants.baseURL)/images/image-1698408236446.png",
            "\(Constants.baseURL)/images/image-1698484500316.png"
        ]),
        .init(id: 7, roomId: 0, senderId: "joker", text: nil, imagePath: [
            "\(Constants.baseURL)/images/image-1698734600855.png",
            "\(Constants.baseURL)/images/image-1698576086660.png",
            "\(Constants.baseURL)/images/image-1698484467680.png",
            "\(Constants.baseURL)/images/image-1698576205201.png",
            "\(Constants.baseURL)/images/image-1698416125741.png",
            "\(Constants.baseURL)/images/image-1698408236446.png",
            "\(Constants.baseURL)/images/image-1698484500316.png"
        ]),
        .init(id: 8, roomId: 0, senderId: "sonny", text: nil, imagePath: [
            "\(Constants.baseURL)/images/image-1698734600855.png",
            "\(Constants.baseURL)/images/image-1698576086660.png",
            "\(Constants.baseURL)/images/image-1698484467680.png",
            "\(Constants.baseURL)/images/image-1698576205201.png",
            "\(Constants.baseURL)/images/image-1698416125741.png",
            "\(Constants.baseURL)/images/image-1698408236446.png",
            "\(Constants.baseURL)/images/image-1698484500316.png"
        ]),
        .init(id: 9, roomId: 0, senderId: "suzylove", text: nil, imagePath: [
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
