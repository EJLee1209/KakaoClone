//
//  SignUpViewController.swift
//  KakaoClone
//
//  Created by 이은재 on 10/26/23.
//

import UIKit
import RxSwift
import RxCocoa

final class SignUpViewController: UIViewController {
    //MARK: - Properties
    
    private lazy var profileImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.setImage(UIImage(named: "default_user_image")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.backgroundColor = .systemGroupedBackground
        button.addTarget(self, action: #selector(handleProfileImageSelect), for: .touchUpInside)
        return button
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
    
    private let nameTextField: UnderlineTextField = {
        let tf = UnderlineTextField(rightViewType: .clearButton)
        tf.textField.placeholder = "이름"
        tf.textField.keyboardType = .emailAddress
        tf.textField.returnKeyType = .next
        tf.textField.autocapitalizationType = .none
        tf.textField.autocorrectionType = .no
        tf.textField.spellCheckingType = .no
        return tf
    }()
        
    private let passwordTextField: UnderlineTextField = {
        let tf = UnderlineTextField(rightViewType: .textVisibilityButton)
        tf.textField.placeholder = "비밀번호(8 ~ 32자)"
        tf.textField.returnKeyType = .next
        tf.textField.autocapitalizationType = .none
        tf.textField.autocorrectionType = .no
        tf.textField.isSecureTextEntry = true
        tf.textField.spellCheckingType = .no
        tf.textField.rightViewMode = .whileEditing
        return tf
    }()
    
    private let passwordConfirmTextField: UnderlineTextField = {
        let tf = UnderlineTextField(rightViewType: .textVisibilityButton)
        tf.textField.placeholder = "비밀번호 확인"
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
        label.text = "비밀번호를 확인해주세요"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemRed
        return label
    }()
    
    private lazy var registerButton: LoadingButton = {
        let button = LoadingButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.systemGray4, for: .disabled)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.clipsToBounds = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleRegisterButtonTapped), for: .touchUpInside)
        button.originalBackgroundColor = .systemYellow
        return button
    }()
    
    private lazy var vStackview: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [idTextField, nameTextField, passwordTextField, passwordConfirmTextField, messageLabel, registerButton])
        sv.axis = .vertical
        sv.spacing = 15
        return sv
    }()
    
    private let bag = DisposeBag()
    private let viewModel: SignUpViewModel

    //MARK: - LifeCycle
    
    init(viewModel: SignUpViewModel) {
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageButton.layer.cornerRadius = profileImageButton.frame.height / 2
    }
    
    //MARK: - Helpers
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func layout() {
        view.backgroundColor = .white
        [profileImageButton, vStackview].forEach(view.addSubview(_:))
        
        profileImageButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.size.equalTo(120)
        }
        
        vStackview.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(50)
            make.horizontalEdges.equalToSuperview().inset(30)
        }
    }
    
    private func bind() {
        let input = SignUpViewModel.Input(
            idObservable: idTextField.textField.rx.text,
            nameObservable: nameTextField.textField.rx.text,
            passwordObservable: passwordTextField.textField.rx.text,
            passwordConfirmObservable: passwordConfirmTextField.textField.rx.text,
            registerButtonTap: registerButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.passwordValidation
            .bind(to: messageLabel.rx.isHidden)
            .disposed(by: bag)
        
        output.registerButtonEnabled
            .bind(to: registerButton.rx.loginButtonEnabled)
            .disposed(by: bag)
        
        output.signUpStateObservable
            .bind { [weak self] state in
                self?.showAlert(state: state)
            }.disposed(by: bag)
    }
    
    private func showAlert(state: APIState) {
        switch state {
        case .success(let response):
            let action = UIAlertAction(title: "확인", style: .default) {[weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            showAlert(title: "회원가입", message: response.message, actions: [action])
            registerButton.isLoading = false
        case .failed(let message):
            let action = UIAlertAction(title: "확인", style: .default)
            showAlert(title: "회원가입", message: message, actions: [action])
            registerButton.isLoading = false
        case .loading:
            registerButton.isLoading = true
        default:
            break
        }
    }
    
    //MARK: - Actions
    @objc private func handleProfileImageSelect() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    @objc private func handleRegisterButtonTapped() {
        viewModel.requestRegistration()
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        viewModel.profileImage = selectedImage
        profileImageButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true)
    }
    
}
