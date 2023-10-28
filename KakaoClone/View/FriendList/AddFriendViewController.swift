//
//  AddFriendViewController.swift
//  KakaoClone
//
//  Created by 이은재 on 10/28/23.
//

import UIKit
import RxSwift
import RxCocoa

protocol AddFriendDelegate: AnyObject {
    func updateFriends()
}

final class AddFriendViewController: UIViewController {
    //MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "카카오톡 ID로 추가"
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var idTextField: UnderlineTextField = {
        let tf = UnderlineTextField(rightViewType: .textCounter, maxLength: 20)
        tf.textField.placeholder = "친구 카카오톡 ID"
        tf.textField.keyboardType = .emailAddress
        tf.textField.returnKeyType = .search
        tf.textField.autocapitalizationType = .none
        tf.textField.autocorrectionType = .no
        tf.textField.spellCheckingType = .no
        tf.textField.rightViewMode = .always
        tf.delegate = self
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
    
    private lazy var friendCardView: FriendCard = {
        let card = FriendCard()
        card.isHidden = true
        card.delegate = self
        return card
    }()
    
    private let noResultLabel: UILabel = {
        let label = UILabel()
        label.text = "검색 결과가 없습니다."
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, idTextField, hStackView, noResultLabel, friendCardView])
        sv.axis = .vertical
        sv.spacing = 18
        return sv
    }()
    
    private let viewModel: AddFriendViewModel
    private let bag = DisposeBag()
    weak var delegate: AddFriendDelegate?
    
    //MARK: - LifeCycle
    
    init(viewModel: AddFriendViewModel) {
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
        let input = AddFriendViewModel.Input(idObservable: idTextField.text.asObservable())
        let output = viewModel.transform(input: input)
        output.searchFriendState
            .bind { [weak self] state in
                self?.changedSearchState(state: state)
            }.disposed(by: bag)
        
        output.addFriendState
            .bind { [weak self] state in
                self?.changedAddFriendState(state: state)
            }.disposed(by: bag)

        output.deleteFriendState
            .bind { [weak self] state in
                self?.changedDeleteFriendState(state: state)
            }.disposed(by: bag)
    }
    
    private func changedSearchState(state: APIState) {
        switch state {
        case .failed:
            friendCardView.isHidden = true
            noResultLabel.isHidden = false
        case .success(let response):
            let response = response as! AuthResponse
            guard let user = response.data else { return }
            friendCardView.isHidden = false
            noResultLabel.isHidden = true
            
            let myFriend = viewModel.friends.filter { $0.id == user.id }
            friendCardView.bind(
                user: user,
                isMine: user.id == viewModel.user.id,
                isAlreadyFriend: myFriend.count != 0
            )
        case .loading:
            friendCardView.isHidden = true
            noResultLabel.isHidden = true
        default:
            break
        }
    }
    private func changedAddFriendState(state: APIState) {
        switch state {
        case .failed(let message):
            print("DEBUG add friend failed: \(message)")
            friendCardView.setButtonState(isLoading: false)
        case .success:
            guard let friend = viewModel.searchResult else { return }
            friendCardView.bind(
                user: friend,
                isMine: viewModel.user.id == friend.id,
                isAlreadyFriend: true
            )
            delegate?.updateFriends()
            friendCardView.setButtonState(isLoading: false)
        case .loading:
            friendCardView.setButtonState(isLoading: true)
            
        default:
            break
        }
    }
    
    private func changedDeleteFriendState(state: APIState) {
        switch state {
        case .failed(let message):
            print("DEBUG delete friend failed: \(message)")
            friendCardView.setButtonState(isLoading: false)
        case .success:
            guard let friend = viewModel.searchResult else { return }
            friendCardView.bind(
                user: friend,
                isMine: viewModel.user.id == friend.id,
                isAlreadyFriend: false
            )
            delegate?.updateFriends()
            friendCardView.setButtonState(isLoading: false)
        case .loading:
            friendCardView.setButtonState(isLoading: true)
        default:
            break
        }
    }
}

//MARK: - UITextFieldDelegate
extension AddFriendViewController: UnderlineTextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) {
        viewModel.search()
    }
}

extension AddFriendViewController: FriendCardDelegate {
    func buttonTap() {
        // 친구 추가
        if friendCardView.isFriend {
            viewModel.deleteFriend()
        } else {
            viewModel.addFriend()
        }
        
    }
}
