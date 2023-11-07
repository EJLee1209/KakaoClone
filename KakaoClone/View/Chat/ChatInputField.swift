//
//  ChatInputField.swift
//  KakaoClone
//
//  Created by 이은재 on 11/1/23.
//

import UIKit
import RxSwift
import RxCocoa

protocol ChatInputFieldDelegate: AnyObject {
    func sendMessage(text: String)
}

final class ChatInputField: UIView {
    //MARK: - Properties
    private lazy var imageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.tintColor = .systemGray2
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }()
    
    private let textFieldBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        view.clipsToBounds = true
        view.layer.cornerRadius = 18
        return view
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        return tf
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = ThemeColor.primary
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var hStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [imageButton, textFieldBackgroundView])
        sv.axis = .horizontal
        sv.spacing = 12
        return sv
    }()
    private let bag = DisposeBag()
    weak var delegate: ChatInputFieldDelegate?
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sendButton.layer.cornerRadius = sendButton.frame.height / 2
    }
    
    //MARK: - Helpers
    private func layout() {
        backgroundColor = .white
        
        [hStackView, textField, sendButton].forEach(addSubview(_:))
        hStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.verticalEdges.equalToSuperview().inset(5)
        }
        sendButton.snp.makeConstraints { make in
            make.verticalEdges.right.equalTo(textFieldBackgroundView).inset(3)
            make.width.equalTo(sendButton.snp.height)
        }
        textField.snp.makeConstraints { make in
            make.verticalEdges.left.equalTo(textFieldBackgroundView).inset(8)
            make.right.equalTo(sendButton.snp.left).inset(8)
        }
        
        textField.rx.text
            .bind(to: sendButton.rx.sendButtonIsHidden)
            .disposed(by: bag)
        
        
    }
    
    //MARK: - Actions
    @objc private func handleTap() {
        guard let text = textField.text else { return }
        delegate?.sendMessage(text: text)
        textField.text = ""
        sendButton.isHidden = true
    }
}

