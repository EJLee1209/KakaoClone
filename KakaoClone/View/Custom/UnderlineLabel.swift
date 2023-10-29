//
//  UnderlineLabe.swift
//  KakaoClone
//
//  Created by 이은재 on 10/29/23.
//

import UIKit

final class UnderlineLabel: UIView {
    //MARK: - Properties
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = "알 수 없음"
        label.textColor = .white
        return label
    }()
    
    lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray2
        view.heightAnchor.constraint(equalToConstant: dividerHeight).isActive = true
        view.alpha = 0
        return view
    }()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, divider])
        sv.axis = .vertical
        sv.spacing = 10
        return sv
    }()
    
    private let space: CGFloat = 8.0
    private let dividerHeight: CGFloat = 1.0
    
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
        
        vStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
