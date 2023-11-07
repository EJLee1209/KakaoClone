//
//  ChatViewController.swift
//  KakaoClone
//
//  Created by 이은재 on 10/31/23.
//

import UIKit
import RxSwift
import RxCocoa

class ChatViewController: UIViewController {
    //MARK: - Properties
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 80
        tv.backgroundColor = .clear
        tv.contentInset = .init(top: 30, left: 0, bottom: 10, right: 0)
        tv.allowsSelection = false
        tv.setContentHuggingPriority(.defaultLow, for: .vertical)
        tv.backgroundColor = ThemeColor.background
        tv.register(MyMessageCell.self, forCellReuseIdentifier: MyMessageCell.id)
        tv.register(OtherMessageCell.self, forCellReuseIdentifier: OtherMessageCell.id)
        tv.register(MyImageCell.self, forCellReuseIdentifier: MyImageCell.id)
        tv.register(OtherImageCell.self, forCellReuseIdentifier: OtherImageCell.id)
        tv.keyboardDismissMode = .onDrag
        return tv
    }()
    
    private lazy var  inputField: ChatInputField = .init()
    
    private let viewModel: ChatViewModel
    private let bag = DisposeBag()
    
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
        observeKeyboardState()
        inputField.delegate = self
        bind()
    }
    
    //MARK: - Helpers
    private func layout() {
        view.backgroundColor = .white
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
        [tableView, inputField].forEach(view.addSubview(_:))
        
        inputField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
//        view.layoutIfNeeded()
        
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
//            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(inputField.frame.height)
            make.bottom.equalTo(inputField.snp.top)
        }
    }
    
    private func bind() {
        viewModel.updateDataSource = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func observeKeyboardState() {
        let keyboardWillShow = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
        let keyboardWillhide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
        
        Observable.merge(keyboardWillShow, keyboardWillhide)
            .bind { [weak self] notification in
                self?.updateConstraintsWhenChangedKeyboardState(notification)
            }.disposed(by: bag)
    }
    
    private func updateConstraintsWhenChangedKeyboardState(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let keyboardHeight = notification.name == UIResponder.keyboardWillShowNotification ? keyboardFrame.height : 0
        
        let originOffset = tableView.contentOffset
        let newOffset: CGPoint
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            newOffset = CGPoint(
                x: originOffset.x,
                y: originOffset.y + (keyboardHeight - inputField.frame.height) + 10
            )
        } else {
            newOffset = originOffset
        }
        
        tableView.setContentOffset(newOffset, animated: true)
    }
}



//MARK: - UICollectionViewDataSource
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isMine = viewModel.dataSource[indexPath.row].isMine(currentUser: viewModel.user)
        let message = viewModel.dataSource[indexPath.row]
        
        switch message.type {
        case .text:
            if isMine {
                let cell = tableView.dequeueReusableCell(withIdentifier: MyMessageCell.id, for: indexPath) as! MyMessageCell
                cell.bind(message: message)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: OtherMessageCell.id, for: indexPath) as! OtherMessageCell
                if let sender = viewModel.friends.filter({ $0.id == message.senderId }).first {
                    cell.setUser(user: sender)
                }
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
                if let sender = viewModel.friends.filter({ $0.id == message.senderId }).first {
                    cell.setUser(user: sender)
                }
                cell.makeUI(message: message)
                
                return cell
            }
        }
    }
}

extension ChatViewController: ChatInputFieldDelegate {
    func sendMessage(text: String) {
        viewModel.sendMessage(text)
        
        tableView.scrollToRow(at: .init(row: viewModel.dataSource.count - 1, section: 0), at: .bottom, animated: false)
    }
}
