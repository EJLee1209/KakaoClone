//
//  FriendListViewModel.swift
//  KakaoClone
//
//  Created by 이은재 on 10/27/23.
//

import Foundation
import RxSwift
import RxRelay

protocol FriendListViewModelDelegate: AnyObject {
    func updateDataSource(_ dataSource: [FriendListSection])
}
final class FriendListViewModel {
    
    weak var delegate: FriendListViewModelDelegate?
    var user: User
    var friends: [User] = []
    var dataSource: [FriendListSection] {
        didSet {
            delegate?.updateDataSource(dataSource)
        }
    }
    let authService: AuthService
    
    private let bag = DisposeBag()
    
    init(user: User, authService: AuthService) {
        self.user = user
        self.authService = authService
        self.dataSource = [
            .userProfileSection(user: user),
            .friendsSection(users: [])
        ]
        
        fetchFriends()
    }
    
    func fetchFriends() {
        authService.fetchFriends(id: user.id)
            .bind { [weak self] response in
                guard let friends = response.data else { return }
                self?.dataSource[1] = .friendsSection(users: friends)
                self?.friends = friends
            }.disposed(by: bag)
    }
    
}
