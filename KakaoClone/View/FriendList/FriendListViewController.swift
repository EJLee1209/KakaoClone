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
        tv.rowHeight = 50
        return tv
    }()
    
    //MARK: - LifeCycle
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

extension FriendListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
