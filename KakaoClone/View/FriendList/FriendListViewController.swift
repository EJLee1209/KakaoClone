//
//  FriendListViewController.swift
//  KakaoClone
//
//  Created by 이은재 on 10/27/23.
//

import UIKit
import RxSwift
import RxCocoa



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
    }
    //MARK: - Helpers
    private func layout() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

//MARK: - UITableViewDataSource
extension FriendListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dataSource.count // Section 수
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.dataSource[section] {
        case .userProfileSection(_): // 사용자 정보 섹션
            return 1
        case .friendsSection(let friends): // 친구 섹션
            return friends.count
        }
    }
    
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
}

//MARK: - UITableViewDelegate
extension FriendListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

