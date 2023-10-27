//
//  LoginViewController.swift
//  KakaoClone
//
//  Created by 이은재 on 10/26/23.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class LoginViewController: UIViewController {
    
    //MARK: - Properties
    private let logoView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "kakao_logo")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let idTextField: UnderlineTextField = {
        let tf = UnderlineTextField(rightViewType: .clearButton)
        tf.textField.placeholder = "카카오 아이디"
        tf.textField.keyboardType = .emailAddress
        tf.textField.returnKeyType = .next
        tf.textField.autocapitalizationType = .none
        tf.textField.autocorrectionType = .no
        tf.textField.spellCheckingType = .no
        return tf
    }()
        
    private let passwordTextField: UnderlineTextField = {
        let tf = UnderlineTextField(rightViewType: .textVisibilityButton)
        tf.textField.placeholder = "비밀번호"
        tf.textField.returnKeyType = .next
        tf.textField.autocapitalizationType = .none
        tf.textField.autocorrectionType = .no
        tf.textField.isSecureTextEntry = true
        tf.textField.spellCheckingType = .no
        tf.textField.rightViewMode = .whileEditing
        return tf
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호는 8 ~ 32자리로 입력할 수 있어요."
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemRed
        return label
    }()
    
    private let loginButton: LoadingButton = {
        let button = LoadingButton()
        button.setTitle("카카오계정 로그인", for: .normal)
        button.setTitleColor(.systemGray4, for: .disabled)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.clipsToBounds = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.originalBackgroundColor = .systemYellow
        return button
    }()
    
    private let spacer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입하러 가기", for: .normal)
        button.addTarget(self, action: #selector(handleRegisterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [idTextField, passwordTextField, messageLabel, loginButton, spacer, registerButton])
        sv.axis = .vertical
        sv.spacing = 15
        return sv
    }()
    
    private let bag = DisposeBag()
    let viewModel: LoginViewModel
    
    
    //MARK: - LifeCycle
    
    init(viewModel: LoginViewModel) {
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func layout() {
        view.backgroundColor = .white
        [logoView, vStackView].forEach(view.addSubview(_:))
        
        logoView.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(80)
        }
        
        vStackView.snp.makeConstraints { make in
            make.top.equalTo(logoView.snp.bottom).offset(50)
            make.horizontalEdges.equalToSuperview().inset(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        let input = LoginViewModel.Input(
            idObservable: idTextField.text,
            passwordObservable: passwordTextField.text,
            loginTap: loginButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.loginButtonEnabled
            .bind(to: loginButton.rx.loginButtonEnabled)
            .disposed(by: bag)
        
        output.passwordFormatLabelIsHidden
            .bind(to: messageLabel.rx.isHidden)
            .disposed(by: bag)
        
        output.signInStateObservable
            .bind { [weak self] state in
                print("DEBUG SignIn State: \(state)")
                self?.showAlert(state: state)
            }.disposed(by: bag)
    }
    
    private func showAlert(state: APIState) {
        switch state {
        case .success(let response):
            if response.status {
                // 로그인 성공
                print("DEBUG Login Success : \(response)")
            } else{
                // 로그인 실패
                let action = UIAlertAction(title: "확인", style: .default)
                showAlert(title: "로그인", message: response.message, actions: [action])
            }
            loginButton.isLoading = false
        case .failed(let message):
            let action = UIAlertAction(title: "확인", style: .default)
            showAlert(title: "로그인", message: message, actions: [action])
            loginButton.isLoading = false
        case .loading:
            loginButton.isLoading = true
        default:
            break
        }
    }
    
    //MARK: - Actions
    
    @objc private func handleRegisterButtonTapped() {
        let vc = SignUpViewController(viewModel: viewModel.makeSignUpViewModel())
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

