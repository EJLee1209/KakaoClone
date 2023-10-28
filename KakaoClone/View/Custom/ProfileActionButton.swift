//
//  ProfileButton.swift
//  KakaoClone
//
//  Created by 이은재 on 10/28/23.
//

import UIKit

enum ProfileActionButtonType {
    case chat
    case editProfile
}

final class ProfileActionButton: UIView {
    //MARK: - Properties
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "bubble.fill")
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = "채팅"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        sv.axis = .vertical
        sv.spacing = 10
        return sv
    }()
    
    let actionType: ProfileActionButtonType
    
    //MARK: - LifeCycle
    init(actionType: ProfileActionButtonType) {
        self.actionType = actionType
        super.init(frame: .zero)
        layout()
        
        switch actionType {
        case .chat:
            iconImageView.image = UIImage(systemName: "bubble.fill")
            titleLabel.text = "채팅"
        case .editProfile:
            iconImageView.image = UIImage(systemName: "pencil")
            titleLabel.text = "프로필 편집"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    private func layout() {
        addSubview(vStackView)

        vStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.height.equalTo(35)
        }
    }
}
