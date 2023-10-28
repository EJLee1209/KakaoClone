//
//  AddFriendViewController.swift
//  KakaoClone
//
//  Created by 이은재 on 10/28/23.
//

import UIKit
import RxSwift
import RxCocoa

final class AddFriendViewController: UIViewController {
    //MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "카카오톡 ID로 추가"
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let idTextField: UnderlineTextField = {
        let tf = UnderlineTextField(rightViewType: .textCounter, maxLength: 20)
        tf.textField.placeholder = "친구 카카오톡 ID"
        tf.textField.keyboardType = .emailAddress
        tf.textField.returnKeyType = .done
        tf.textField.autocapitalizationType = .none
        tf.textField.autocorrectionType = .no
        tf.textField.spellCheckingType = .no
        tf.textField.rightViewMode = .always
        return tf
    }()
    
    private let myIDTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 아이디"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var idLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.text = viewModel.user.id
        return label
    }()
    
    private lazy var hStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [myIDTitleLabel, idLabel])
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        return sv
    }()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, idTextField, hStackView])
        sv.axis = .vertical
        sv.spacing = 18
        return sv
    }()
    
    private let viewModel: FriendListViewModel
    
    //MARK: - LifeCycle
    
    init(viewModel: FriendListViewModel) {
        self.viewModel = viewModel
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
        view.backgroundColor = .white
        view.addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(18)
        }
    }
    
    private func bind() {
        
    }


}
