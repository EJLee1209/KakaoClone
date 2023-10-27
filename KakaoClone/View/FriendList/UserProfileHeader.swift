//
//  UserProfileHeader.swift
//  KakaoClone
//
//  Created by 이은재 on 10/27/23.
//

import UIKit
import SDWebImage

final class UserProfileHeader: UITableViewHeaderFooterView {
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
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    
    private let stateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray4
        return label
    }()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nameLabel, stateLabel])
        sv.axis = .vertical
        sv.spacing = 2
        return sv
    }()
    
    private lazy var hStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [profileImageView, vStackView])
        sv.axis = .horizontal
        sv.spacing = 8
        return sv
    }()
    
    static let id = "UserProfileHeader"
    
    //MARK: - Lifecycle
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func layout() {
        contentView.addSubview(hStackView)
        hStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(80)
        }
    }
    func bind(user: User) {
        nameLabel.text = user.name
        stateLabel.text = user.stateMessage
        stateLabel.isHidden = user.stateMessage == nil
        profileImageView.sd_setImage(with: user.imageUrl)
    }
    
}
