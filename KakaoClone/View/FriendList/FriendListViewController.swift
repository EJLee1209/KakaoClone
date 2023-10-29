//
//  FriendListViewController.swift
//  KakaoClone
//
//  Created by 이은재 on 10/27/23.
//

import UIKit
import RxSwift
import RxCocoa

protocol FriendListViewControllerDelegate: AnyObject {
    func logout()
}

final class FriendListViewController: UIViewController {
    //MARK: - Properties
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.delegate = self
        tv.rowHeight = 50
        tv.register(FriendCell.self, forCellReuseIdentifier: FriendCell.id)
        tv.rowHeight = UITableView.automaticDimension
        return tv
    }()
    
    private let viewModel: FriendListViewModel
    weak var delegate: FriendListViewControllerDelegate?
    
    //MARK: - LifeCycle
    
    init(viewModel: FriendListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        setupNavBarItems()
    }
    //MARK: - Helpers
    private func layout() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNavBarItems() {
        let logoutButton = UIBarButtonItem(
            title: "로그아웃",
            style: .plain,
            target: self,
            action: #selector(handleLogout)
        )
        let addFriendButton = UIBarButtonItem(
            image: UIImage(systemName: "person.badge.plus"),
            style: .plain,
            target: self,
            action: #selector(handleAddFriend)
        )
        
        navigationItem.setLeftBarButton(logoutButton, animated: true)
        navigationItem.setRightBarButton(addFriendButton, animated: true)
    }
    
    //MARK: - Actions
    @objc func handleLogout() {
        let positiveAction = UIAlertAction(title: "로그아웃", style: .destructive) { [weak self] _ in
            // 로그아웃
            self?.delegate?.logout()
        }
        let negativeAction = UIAlertAction(title: "취소", style: .cancel)
        
        showAlert(
            title: "로그아웃",
            message: "정말로 로그아웃 하시겠습니까?",
            actions: [positiveAction, negativeAction]
        )
    }
    
    @objc func handleAddFriend() {
        let vm = AddFriendViewModel(
            user: viewModel.user,
            friends: viewModel.friends,
            authService: viewModel.authService
        )
        let vc = AddFriendViewController(viewModel: vm)
        vc.delegate = self
        present(vc, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension FriendListViewController: UITableViewDataSource {
    // number of section
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dataSource.count // Section 수
    }
    // number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.dataSource[section] {
        case .userProfileSection(_): // 사용자 정보 섹션
            return 1
        case .friendsSection(let friends): // 친구 섹션
            return friends.count
        }
    }
    // tableView cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.id, for: indexPath) as! FriendCell
        
        switch viewModel.dataSource[indexPath.section] {
        case .friendsSection(let friends):
            cell.bind(user: friends[indexPath.row], isMine: false)
        case .userProfileSection(let user):
            cell.bind(user: user, isMine: true)
        }
        
        return cell
    }
    
    // Section Title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionName: String
        switch viewModel.dataSource[section] {
        case .friendsSection(let friends):
            sectionName = "친구 \(friends.count)명"
        case .userProfileSection(_):
            sectionName = "내 프로필"
        }
        return sectionName
    }
}

//MARK: - UITableViewDelegate
extension FriendListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vm: FriendDetailViewModel
        
        switch viewModel.dataSource[indexPath.section] {
        case .friendsSection(let friends):
            vm = .init(user: viewModel.user, selectedFriend: friends[indexPath.row], authService: viewModel.authService)
        case .userProfileSection(let user):
            vm = .init(user: user, selectedFriend: nil, authService: viewModel.authService)
        }
        
        let vc = FriendDetailViewController(viewModel: vm)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
}

//MARK: - FriendListViewModelDelegate
extension FriendListViewController: FriendListViewModelDelegate {
    func updateDataSource(_ dataSource: [FriendListSection]) {
        tableView.reloadData()
    }
}

//MARK: - AddFriendDelegate
extension FriendListViewController: AddFriendDelegate {
    func updateFriends() {
        viewModel.fetchFriends()
    }
}
