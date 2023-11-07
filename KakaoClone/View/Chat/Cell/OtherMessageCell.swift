//
//  OtherMessageCell.swift
//  KakaoClone
//
//  Created by 이은재 on 10/31/23.
//

import UIKit

final class OtherMessageCell: UITableViewCell {
    //MARK: - Properties
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGroupedBackground
        iv.image = #imageLiteral(resourceName: "default_user_image")
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .systemGray2
        label.text = "알 수 없음"
        return label
    }()
    
    private let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .systemGray2
        return label
    }()
    
    private lazy var hStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [bubbleView, dateLabel])
        sv.axis = .horizontal
        sv.spacing = 4
        sv.alignment = .bottom
        return sv
    }()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nameLabel, hStackView])
        sv.axis = .vertical
        sv.spacing = 4
        return sv
    }()
    
    static let id = "OtherMessageCell"
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func layout() {
        backgroundColor = .clear
        
        [profileImageView, vStackView, messageLabel].forEach(contentView.addSubview(_:))
        
        profileImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(15)
            make.size.equalTo(30)
        }
        
        vStackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.width.lessThanOrEqualTo(UIScreen.main.bounds.width - 100)
            make.left.equalTo(profileImageView.snp.right).offset(4)
            make.bottom.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints { make in
            make.edges.equalTo(bubbleView).inset(8)
        }
        
        layoutIfNeeded()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2.5
    }
    func bind(message: ChatMessage){
        messageLabel.text = message.message
        dateLabel.text = message.timestamp.makePrettyDateTime()
    }
    
    func setUser(user: User) {
        profileImageView.sd_setImage(with: user.imageUrl)
        nameLabel.text = user.name
    }
}
