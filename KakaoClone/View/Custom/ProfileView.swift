//
//  ProfileView.swift
//  KakaoClone
//
//  Created by 이은재 on 10/28/23.
//

import UIKit

final class ProfileView : UIView {
    
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
        label.text = "알 수 없음"
        label.textColor = .white
        return label
    }()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [profileImageView, nameLabel])
        sv.axis = .vertical
        sv.spacing = 4
        return sv
    }()
    
    override var intrinsicContentSize: CGSize {
        return .init(width: vStackView.frame.width, height: vStackView.frame.height)
    }
    
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
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2.5
    }
    
    func bind(imageURL: URL?, name: String) {
        profileImageView.sd_setImage(with: imageURL)
        nameLabel.text = name
    }
}
