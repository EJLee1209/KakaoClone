//
//  FriendCard.swift
//  KakaoClone
//
//  Created by 이은재 on 10/28/23.
//

import UIKit

protocol FriendCardDelegate: AnyObject {
    func buttonTap()
}

final class FriendCard: UIView {
    
    //MARK: - Properties
    private let profileView: ProfileView = {
        let view = ProfileView()
        view.nameLabel.titleLabel.textColor = .black
        view.stateMessageLabel.titleLabel.textColor = .systemGray2
        return view
    }()
    
    private lazy var addFriendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("친구 추가", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemYellow
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        return button
    }()

    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [profileView, addFriendButton])
        sv.axis = .vertical
        sv.spacing = 18
        return sv
    }()
    
    weak var delegate: FriendCardDelegate?
    var isFriend: Bool = false
    
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    private func layout() {
        backgroundColor = .systemGroupedBackground
        clipsToBounds = true
        layer.cornerRadius = 8
        
        addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(30)
        }
        
    }
    
    func bind(
        user: User,
        isMine: Bool,
        isAlreadyFriend: Bool
    ) {
        profileView.bind(user: user, isSelectedImage: false)
        
        addFriendButton.isHidden = isMine
        addFriendButton.setTitle(isAlreadyFriend ? "친구 삭제" : "친구 추가", for: .normal)
        addFriendButton.backgroundColor = isAlreadyFriend ? UIColor.systemRed : UIColor.systemYellow
        addFriendButton.setTitleColor(isAlreadyFriend ? .white : .black, for: .normal)
        isFriend = isAlreadyFriend
    }
    
    func setButtonState(isLoading: Bool) {
        addFriendButton.isEnabled = !isLoading
    }
    
    
    
    //MARK: - Actions
    
    @objc func handleTap() {
        delegate?.buttonTap()
    }
}
