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
    let authService: AuthService
    let searchState: BehaviorRelay<APIState> = .init(value: .none)
    private let bag = DisposeBag()
    
    private var id: String = ""
    
    struct Input {
        let idObservable: Observable<String?>
    }
    struct Output {
        let searchFriendState: Observable<APIState>
    }
    
    init(user: User, authService: AuthService) {
        self.user = user
        self.authService = authService
    }
    
    func transform(input: Input) -> Output {
        input.idObservable
            .compactMap { $0 }
            .bind { [weak self] id in
                self?.id = id
            }.disposed(by: bag)
        
        return Output(
            searchFriendState: searchState.asObservable()
        )
    }
    
    
    func search() {
        searchState.accept(.loading)
        
        authService.fetchUser(id: id)
            .subscribe { [weak self] response in
                self?.searchState.accept(.success(response))
            } onError: { [weak self] error in
                if let error = error as? APIError {
                    self?.searchState.accept(.failed(error.customDescription))
                }
            }.disposed(by: bag)
    }
}
