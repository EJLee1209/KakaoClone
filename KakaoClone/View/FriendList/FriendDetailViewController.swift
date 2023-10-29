//
//  FriendDetailViewController.swift
//  KakaoClone
//
//  Created by 이은재 on 10/28/23.
//

import UIKit

class FriendDetailViewController: UIViewController {
    //MARK: - Properties
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .close)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()
    
    private lazy var editCancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle("취소", for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var editCompleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle("완료", for: .normal)
        button.addTarget(self, action: #selector(handleComplete), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private let profileView: ProfileView = .init()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray2
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    private let chatButton = ProfileActionButton(actionType: .chat)
    private let editProfileButton = ProfileActionButton(actionType: .editProfile)
    
    private lazy var hStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [chatButton, editProfileButton])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        return sv
    }()
    
    private let spacer: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return view
    }()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [profileView, spacer, divider, hStackView])
        sv.axis = .vertical
        sv.spacing = 15
        return sv
    }()
    
    private let viewModel: FriendDetailViewModel
    
    //MARK: - LifeCycle
    
    init(viewModel: FriendDetailViewModel) {
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
        setupDelegate()
    }
    
    
    //MARK: - Helpers
    private func layout() {
        view.backgroundColor = ThemeColor.background
        [closeButton, editCancelButton, editCompleteButton, vStackView].forEach(view.addSubview(_:))

        closeButton.snp.makeConstraints { make in
            make.left.top.equalTo(view.safeAreaLayoutGuide).inset(18)
        }
        editCancelButton.snp.makeConstraints { make in
            make.left.top.equalTo(view.safeAreaLayoutGuide).inset(18)
        }
        editCompleteButton.snp.makeConstraints { make in
            make.right.top.equalTo(view.safeAreaLayoutGuide).inset(18)
        }
        
        vStackView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        if let selectedFriend = viewModel.selectedFriend {
            // 친구 프로필
            profileView.bind(user: selectedFriend, isSelectedImage: false)
            editProfileButton.isHidden = true
        } else {
            // 내 프로필
            profileView.bind(user: viewModel.user, isSelectedImage: false)
        }
    }
    
    private func setupDelegate() {
        chatButton.delegate = self
        editProfileButton.delegate = self
        profileView.delegate = self
    }
    
    private func updateButtonIsHidden(isEditing: Bool) {
        profileView.isEditing.toggle()
        editCancelButton.isHidden.toggle()
        editCompleteButton.isHidden.toggle()
        closeButton.isHidden.toggle()
        divider.alpha = isEditing ? 0 : 1
        hStackView.alpha = isEditing ? 0 : 1
    }
    
    private func handleProfileImageSelect() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    //MARK: - Actions
    @objc func handleClose() {
        dismiss(animated: true)
    }
    
    @objc func handleCancel() {
        // 프로필 편집 취소
        updateButtonIsHidden(isEditing: false)
    }
    
    @objc func handleComplete() {
        // 프로필 편집 완료
        updateButtonIsHidden(isEditing: false)
        viewModel.updateUser()
    }
    
}

//MARK: - ProfileActionButtonDelegate
extension FriendDetailViewController: ProfileActionButtonDelegate {
    func tap(buttonType: ProfileActionButtonType) {
        switch buttonType {
        case .chat:
            print("DEBUG 채팅 버튼 탭")
        case .editProfile:
            updateButtonIsHidden(isEditing: true)
        }
    }
}

//MARK: - ProfileViewDelegate
extension FriendDetailViewController: ProfileViewDelegate {
    func tapName() {
        goToEditDetailVC(editType: .name)
    }
    func tapStateMessage() {
        goToEditDetailVC(editType: .stateMessage)
    }
    func tapProfileImage() {
        print("DEBUG tapProfileImage")
        handleProfileImageSelect()
    }
    
    func goToEditDetailVC(editType: ProfileEditType) {
        let vc = EditDetailViewController(viewModel: viewModel, editType: editType)
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        present(vc, animated: false)
    }
}

//MARK: - EditDetailViewControllerDelegate
extension FriendDetailViewController: EditDetailViewControllerDelegate {
    // 이름 또는 상태메시지 수정
    func complete(editType: ProfileEditType, text: String) {
        switch editType {
        case .name:
            viewModel.user.name = text
            profileView.nameLabel.titleLabel.text = text
            profileView.bind(user: viewModel.user, isSelectedImage: viewModel.selectedProfileImage != nil)
        case .stateMessage:
            viewModel.user.stateMessage = text
            profileView.stateMessageLabel.titleLabel.text = text
            profileView.bind(user: viewModel.user, isSelectedImage: viewModel.selectedProfileImage != nil)
        }
    }
}

//MARK: - UIImagePickerControllerDelegate
extension FriendDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        profileView.setProfileImage(selectedImage)
        viewModel.selectedProfileImage = selectedImage
        self.dismiss(animated: true)
    }
    
}
