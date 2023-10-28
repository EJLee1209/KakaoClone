//
//  FriendDetailViewController.swift
//  KakaoClone
//
//  Created by 이은재 on 10/28/23.
//

import UIKit

class FriendDetailViewController: UIViewController {
    //MARK: - Properties
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .close)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()
    
    private let profileView: ProfileView = .init()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray2
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    private let chatButton = ProfileActionButton(actionType: .chat)
    private let editProfileButton = ProfileActionButton(actionType: .editProfile)
    
    private lazy var hStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [chatButton, editProfileButton])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        return sv
    }()
    
    private let spacer: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [profileView, spacer, divider, hStackView])
        sv.axis = .vertical
        sv.spacing = 10
        return sv
    }()
    
    private let viewModel: FriendDetailViewModel
    
    //MARK: - LifeCycle
    
    init(viewModel: FriendDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
        bind()
    }
    
    
    //MARK: - Helpers
    private func layout() {
        view.backgroundColor = ThemeColor.background
        [closeButton, vStackView].forEach(view.addSubview(_:))

        closeButton.snp.makeConstraints { make in
            make.left.top.equalTo(view.safeAreaLayoutGuide).inset(18)
        }
        vStackView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        if let selectedFriend = viewModel.selectedFriend {
            // 친구 프로필
            profileView.bind(imageURL: selectedFriend.imageUrl, name: selectedFriend.name)
            editProfileButton.isHidden = true
        } else {
            // 내 프로필
            profileView.bind(imageURL: viewModel.user.imageUrl, name: viewModel.user.name)
        }
    }
    
    //MARK: - Actions
    @objc func handleClose() {
        dismiss(animated: true)
    }
}
