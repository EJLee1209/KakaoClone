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
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "default_user_image")
        iv.backgroundColor = .systemGroupedBackground
        iv.clipsToBounds = true
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
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
        let sv = UIStackView(arrangedSubviews: [profileImageView, nameLabel, addFriendButton])
        sv.axis = .vertical
        sv.spacing = 18
        return sv
    }()
    
    weak var delegate: FriendCardDelegate?
    
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
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(80)
        }
        layoutIfNeeded()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2.5
    }
    
    func bind(
        user: User,
        isMine: Bool
    ) {
        profileImageView.sd_setImage(with: user.imageUrl)
        nameLabel.text = user.name
        
        addFriendButton.isHidden = isMine
    }
    
    //MARK: - Actions
    
    @objc func handleTap() {
        delegate?.buttonTap()
    }
}