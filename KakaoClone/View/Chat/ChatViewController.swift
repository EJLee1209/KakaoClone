//
//  ChatViewController.swift
//  KakaoClone
//
//  Created by 이은재 on 10/31/23.
//

import UIKit

struct Message: Codable {
    let id: Int
    let roomId: Int
    let senderId: String
    let text: String?
    let imagePath: [String]?
    
    var type: MessageType {
        guard let imagePath = imagePath else {
            return .text(message: text!)
        }
        let images = imagePath.map { URL(string: $0) }
        return .image(images)
    }
    
    func isMine(currentUser: User) -> Bool {
        return currentUser.id == senderId
    }
}

enum MessageType {
    case image([URL?])
    case text(message: String)
}

class ChatViewController: UIViewController {
    //MARK: - Properties
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 10
        cv.contentInsetAdjustmentBehavior = .always
        cv.dataSource = self
        return cv
    }()
    
    private let dataSource: [Message] = [
        .init(id: 0, roomId: 0, senderId: "suzylove", text: "안녕하세요", imagePath: nil),
        .init(id: 1, roomId: 0, senderId: "dldmswo1209", text: "안녕", imagePath: nil),
        .init(id: 2, roomId: 0, senderId: "sonny", text: nil, imagePath: [
            "\(Constants.baseURL)/images/image-1698484500316.png",
            "\(Constants.baseURL)/images/image-1698484500316.png",
            "\(Constants.baseURL)/images/image-1698484500316.png",
            "\(Constants.baseURL)/images/image-1698484500316.png",
            "\(Constants.baseURL)/images/image-1698484500316.png"
        ]),
        .init(id: 3, roomId: 0, senderId: "dldmswo1209", text: "우와 월클 손흥민!", imagePath: nil),
        .init(id: 4, roomId: 0, senderId: "suzylove", text: "어맛...", imagePath: nil),
    ]
    
    private let viewModel: ChatViewModel
    
    //MARK: - LifeCycle
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    //MARK: - Helpers
    
}

extension ChatViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let isMine = dataSource[indexPath.row].isMine(currentUser: viewModel.user)
        
        switch dataSource[indexPath.row].type {
        case .text(let message):
            break
        case .image(let imageUrls):
            break
        }
        
    }
    
    
}
