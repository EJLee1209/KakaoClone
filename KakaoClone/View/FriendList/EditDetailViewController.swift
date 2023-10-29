//
//  EditDetailViewController.swift
//  KakaoClone
//
//  Created by 이은재 on 10/29/23.
//

import UIKit
import RxSwift

enum ProfileEditType: String {
    case name = "이름"
    case stateMessage = "상태 메시지"
}

protocol EditDetailViewControllerDelegate: AnyObject {
    func complete(editType: ProfileEditType, text: String)
}

class EditDetailViewController: UIViewController {
    //MARK: - Properties
    private lazy var editCancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle("취소", for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    private lazy var editCompleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.systemGray2, for: .disabled)
        button.addTarget(self, action: #selector(handleComplete), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.text = "이름"
        return label
    }()
    
    private let textField: UnderlineTextField = {
        let tf = UnderlineTextField(rightViewType: .textCounter, maxLength: 20)
        tf.textField.returnKeyType = .done
        tf.textField.autocapitalizationType = .none
        tf.textField.autocorrectionType = .no
        tf.textField.spellCheckingType = .no
        tf.textField.rightViewMode = .always
        tf.textField.textColor = .white
        tf.textField.textAlignment = .center
        return tf
    }()
    
    private lazy var hStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [editCancelButton, titleLabel, editCompleteButton])
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        return sv
    }()
    
    private let viewModel: FriendDetailViewModel
    private let bag = DisposeBag()
    let editType: ProfileEditType
    weak var delegate: EditDetailViewControllerDelegate?
    
    //MARK: - LifeCycle
    
    init(viewModel: FriendDetailViewModel, editType: ProfileEditType) {
        self.viewModel = viewModel
        self.editType = editType
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        bind()
    }
    
    //MARK: - Helpers
    private func layout() {
        view.backgroundColor = .black.withAlphaComponent(0.8)
        view.addSubview(hStackView)
        hStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(18)
        }
        
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    private func bind() {
        textField.textField.text = editType == .name ? viewModel.user.name : viewModel.user.stateMessage
        titleLabel.text = editType.rawValue
        
        textField.text
            .bind(to: editCompleteButton.rx.editButtonIsEnabled)
            .disposed(by: bag)
    }
    
    //MARK: - Actions
    @objc private func handleCancel() {
        dismiss(animated: false)
    }
    @objc private func handleComplete() {
        dismiss(animated: false)
        guard let text = textField.textField.text else { return }
        delegate?.complete(editType: editType, text: text)
    }
}


