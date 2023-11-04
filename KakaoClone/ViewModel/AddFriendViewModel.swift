//
//  AddFriendViewModel.swift
//  KakaoClone
//
//  Created by 이은재 on 10/28/23.
//

import Foundation
import RxSwift
import RxRelay

final class AddFriendViewModel {
    
    let user: User
    let friends: [User]
    let authService: AuthService
    let searchState: BehaviorRelay<APIState> = .init(value: .none)
    let addFriendState: BehaviorRelay<APIState> = .init(value: .none)
    let deleteFriendState: BehaviorRelay<APIState> = .init(value: .none)
    private let bag = DisposeBag()
    
    private var id: String = ""
    var searchResult: User?
    
    struct Input {
        let idObservable: Observable<String?>
    }
    struct Output {
        let searchFriendState: Observable<APIState>
        let addFriendState: Observable<APIState>
        let deleteFriendState: Observable<APIState>
    }
    
    init(user: User, friends: [User], authService: AuthService) {
        self.user = user
        self.friends = friends
        self.authService = authService
    }
    
    func transform(input: Input) -> Output {
        input.idObservable
            .compactMap { $0 }
            .bind { [weak self] id in
                self?.id = id
            }.disposed(by: bag)
        
        return Output(
            searchFriendState: searchState.asObservable(),
            addFriendState: addFriendState.asObservable(),
            deleteFriendState: deleteFriendState.asObservable()
        )
    }
    
    
    func search() {
        searchState.accept(.loading)
        
        authService.fetchUser(id: id)
            .subscribe { [weak self] response in
                self?.searchState.accept(.success(response))
                self?.searchResult = response.data
            } onError: { [weak self] error in
                if let error = error as? APIError {
                    self?.searchState.accept(.failed(error.customDescription))
                }
                self?.searchResult = nil
            }.disposed(by: bag)
    }
    
    func addFriend() {
        guard let targetUser = self.searchResult else { return }
        addFriendState.accept(.loading)
        
        authService.addFriend(fromId: user.id, toId: targetUser.id)
            .subscribe { [weak self] isSuccess in
                self?.addFriendState.accept(.success(isSuccess))
            } onError: { [weak self] error in
                if let error = error as? APIError {
                    self?.addFriendState.accept(.failed(error.customDescription))
                }
            }.disposed(by: bag)
    }
    
    func deleteFriend() {
        guard let targetUser = self.searchResult else { return }
        deleteFriendState.accept(.loading)
        
        authService.deleteFriend(fromId: user.id, toId: targetUser.id)
            .subscribe { [weak self] isSuccess in
                self?.deleteFriendState.accept(.success(isSuccess))
            } onError: { [weak self] error in
                if let error = error as? APIError {
                    self?.deleteFriendState.accept(.failed(error.customDescription))
                }
            }.disposed(by: bag)
    }
}
