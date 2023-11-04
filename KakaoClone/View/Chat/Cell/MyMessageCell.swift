//
//  MyMessageCell.swift
//  KakaoClone
//
//  Created by 이은재 on 10/31/23.
//

import UIKit

final class MyMessageCell: UITableViewCell {
    //MARK: - Properties
    
    private let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.primary
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
        let sv = UIStackView(arrangedSubviews: [dateLabel, bubbleView])
        sv.axis = .horizontal
        sv.alignment = .bottom
        sv.spacing = 4
        return sv
    }()
    
    static let id = "MyMessageCell"
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
        
        [hStackView, messageLabel].forEach(contentView.addSubview(_:))
        
        hStackView.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints { make in
            make.edges.equalTo(bubbleView).inset(8)
            make.width.lessThanOrEqualTo(UIScreen.main.bounds.width - 100)
        }
    }
    func bind(message: ChatMessage){
        messageLabel.text = message.message
        dateLabel.text = message.timestamp.formattedDateString(dateFormat: "a hh:mm")
    }
    
}


