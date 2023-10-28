//
//  UnderlineTextField.swift
//  KakaoClone
//
//  Created by 이은재 on 10/26/23.
//

import UIKit
import RxCocoa
import RxSwift

enum RightViewType {
    case clearButton
    case textVisibilityButton
    case textCounter
    case none
}

final class UnderlineTextField: UIView {
    //MARK: - Properties
    let textField: UITextField = .init()
    private let divider1: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    private lazy var eyeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye.slash")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.tintColor = .systemGray5
        button.addTarget(self, action: #selector(handleEyeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var textCounter: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray2
        label.text = "0/0"
        return label
    }()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [textField, divider1])
        sv.axis = .vertical
        sv.spacing = 15
        return sv
    }()
    
    private let rightViewType: RightViewType
    private let bag = DisposeBag()
    let maxLength: Int
    
    var text: ControlProperty<String?> {
        return textField.rx.text
    }
    
    
    override var intrinsicContentSize: CGSize {
        return .init(width: vStackView.frame.width, height: vStackView.frame.height)
    }
    
    
    //MARK: - LifeCycle
    init(
        rightViewType: RightViewType,
        maxLength: Int
    ) {
        self.rightViewType = rightViewType
        self.maxLength = maxLength
        
        super.init(frame: .zero)
        textField.delegate = self
        layout()
        
        switch rightViewType {
        case .clearButton:
            textField.clearButtonMode = .whileEditing
        case .textVisibilityButton:
            textField.rightView = eyeButton
        case .textCounter:
            textField.rightView = textCounter
            textField.rx.text
                .bind { [weak self] text in
                    guard let text = text, let maxLength = self?.maxLength else { return }
                    self?.textCounter.text = "\(text.count)/\(maxLength)"
                }
                .disposed(by: bag)
        case .none:
            break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func layout() {
        addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }
        
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
    }
    
    //MARK: - Actions
    
    @objc private func handleEyeTapped() {
        textField.isSecureTextEntry.toggle()
        let eyeImage = textField.isSecureTextEntry ? UIImage(systemName: "eye.slash") : UIImage(systemName: "eye.fill")
        eyeButton.setImage(eyeImage, for: .normal)
    }
}

extension UnderlineTextField: UITextFieldDelegate {
    
    // UITextFieldDelegate 메서드 - 텍스트 입력이 변경될 때 호출됨
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.count + string.count - range.length
        return newLength <= self.maxLength // 길이 제한
    }
    
}
