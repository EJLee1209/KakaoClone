//
//  ProfileView.swift
//  KakaoClone
//
//  Created by 이은재 on 10/28/23.
//

import UIKit

protocol ProfileViewDelegate: AnyObject {
    func tapName()
    func tapStateMessage()
    func tapProfileImage()
}

final class ProfileView : UIView {
    
    //MARK: - Properties
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "default_user_image")
        iv.backgroundColor = .systemGroupedBackground
        iv.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTap))
        iv.addGestureRecognizer(tapGesture)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let cameraIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "camera.circle.fill")
        iv.contentMode = .scaleAspectFill
        iv.tintColor = .white
        iv.clipsToBounds = true
        iv.isHidden = true
        return iv
    }()
    
    lazy var nameLabel: UnderlineLabel = {
        let label = UnderlineLabel()
        label.titleLabel.font = .boldSystemFont(ofSize: 16)
        label.titleLabel.textAlignment = .center
        label.titleLabel.text = "알 수 없음"
        label.titleLabel.textColor = .white
        label.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40).isActive = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleNameTap))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    lazy var stateMessageLabel: UnderlineLabel = {
        let label = UnderlineLabel()
        label.titleLabel.font = .boldSystemFont(ofSize: 14)
        label.titleLabel.textAlignment = .center
        label.titleLabel.textColor = .white
        label.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40).isActive = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleStateMessageTap))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [profileImageView, nameLabel, stateMessageLabel])
        sv.axis = .vertical
        sv.spacing = 10
        sv.alignment = .center
        return sv
    }()
    
    override var intrinsicContentSize: CGSize {
        return .init(width: vStackView.frame.width, height: vStackView.frame.height)
    }
    
    var isEditing: Bool = false {
        didSet {
            changedMode()
        }
    }
    
    weak var delegate: ProfileViewDelegate?
    private var user: User?
    
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
        addSubview(vStackView)
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(80)
        }
        vStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        addSubview(cameraIconImageView)
        cameraIconImageView.snp.makeConstraints { make in
            make.bottom.right.equalTo(profileImageView)
            make.size.equalTo(25)
        }
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2.5
        cameraIconImageView.layer.cornerRadius = cameraIconImageView.frame.height / 2.5
    }
    
    func bind(user: User, isSelectedImage: Bool) {
        if !isSelectedImage {
            profileImageView.sd_setImage(with: user.imageUrl)
        }
        nameLabel.titleLabel.text = user.name
        stateMessageLabel.titleLabel.text = user.stateMessage == nil ? " " : user.stateMessage
        self.user = user
    }
    
    private func changedMode() {
        cameraIconImageView.isHidden = !isEditing
        [nameLabel, stateMessageLabel].forEach { $0.divider.alpha = isEditing ? 1 : 0 }
        if isEditing {
            stateMessageLabel.titleLabel.text = user?.stateMessage == nil ? "상태 메시지를 입력해주세요" : user?.stateMessage!
        } else {
            stateMessageLabel.titleLabel.text = user?.stateMessage == nil ? " " : user?.stateMessage!
        }
    }
    
    func setProfileImage(_ image: UIImage?) {
        profileImageView.image = image
    }
    
    //MARK: - Actions
    @objc private func handleNameTap() {
        if isEditing {
            delegate?.tapName()
        }
    }
    @objc private func handleStateMessageTap() {
        if isEditing {
            delegate?.tapStateMessage()
        }
    }
    
    @objc private func handleProfileImageTap() {
        if isEditing {
            delegate?.tapProfileImage()
        }
    }
}
