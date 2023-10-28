//
//  FriendCell.swift
//  KakaoClone
//
//  Created by 이은재 on 10/27/23.
//

import Foundation
import UIKit
import SDWebImage

final class FriendCell: UITableViewCell {
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
        return label
    }()
    
    private let stateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray2
        return label
    }()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nameLabel, stateLabel])
        sv.axis = .vertical
        sv.spacing = 3
        return sv
    }()
    
    private lazy var hStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [profileImageView, vStackView])
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        return sv
    }()
    
    static let id = "FriendCell"
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2.5
    }
    
    //MARK: - Helpers
    private func layout() {
        contentView.addSubview(hStackView)
        hStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
    }
    
    func bind(user: User, isMine: Bool) {
        nameLabel.text = user.name
        stateLabel.text = user.stateMessage
        stateLabel.isHidden = user.stateMessage == nil
        profileImageView.sd_setImage(with: user.imageUrl)
        
        if isMine {
            profileImageView.snp.updateConstraints { make in
                make.size.equalTo(80)
            }
        }
    }
}
