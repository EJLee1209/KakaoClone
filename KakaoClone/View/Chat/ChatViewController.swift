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
    var dateTime: Date = Date()
    
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

enum MessageType {
    case image
    case text
}

class ChatViewController: UIViewController {
    //MARK: - Properties
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 80
        tv.register(MyMessageCell.self, forCellReuseIdentifier: MyMessageCell.id)
        tv.register(OtherMessageCell.self, forCellReuseIdentifier: OtherMessageCell.id)
        tv.register(MyImageCell.self, forCellReuseIdentifier: MyImageCell.id)
        tv.register(OtherImageCell.self, forCellReuseIdentifier: OtherImageCell.id)
        tv.backgroundColor = .clear
        tv.contentInset = .init(top: 30, left: 0, bottom: 30, right: 0)
        tv.allowsSelection = false
        return tv
    }()
    
    private let dataSource: [Message] = [
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
        layout()
    }
    
    //MARK: - Helpers
    private func layout() {
        view.backgroundColor = ThemeColor.background
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}



//MARK: - UICollectionViewDataSource
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isMine = dataSource[indexPath.row].isMine(currentUser: viewModel.user)
        let message = dataSource[indexPath.row]
        
        switch message.type {
        case .text:
            if isMine {
                let cell = tableView.dequeueReusableCell(withIdentifier: MyMessageCell.id, for: indexPath) as! MyMessageCell
                cell.bind(message: message)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: OtherMessageCell.id, for: indexPath) as! OtherMessageCell
                cell.bind(message: message)
                return cell
            }
        case .image:
            if isMine {
                let cell = MyImageCell()
                cell.makeUI(message: message)
                return cell
            } else {
                let cell = OtherImageCell()
                cell.makeUI(message: message)
                return cell
            }
        }
    }
    
    
    
}
