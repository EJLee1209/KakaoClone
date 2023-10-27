//
//  MainTabViewController.swift
//  KakaoClone
//
//  Created by 이은재 on 10/27/23.
//

import UIKit

final class MainTabViewController: UITabBarController {
    //MARK: - Properties

    let viewModel: MainViewModel
    
    //MARK: - LifeCycle
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let loginVM = viewModel.checkLogin() else {
            // 이미 로그인함
            configureViewControllers()
            return
        }
        // 로그인 필요
        let loginVC = LoginViewController(viewModel: loginVM)
        loginVC.delegate = self
        let nav = UINavigationController(rootViewController: loginVC)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
    //MARK: - Helpers
    
    
    private func configureViewControllers() {
        
        let friends = templateNavigationController(
            unselectedImage: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill"),
            rootViewController: FriendListViewController()
        )
        let chats = templateNavigationController(
            unselectedImage: UIImage(systemName: "bubble"),
            selectedImage: UIImage(systemName: "bubble.fill"),
            rootViewController: FriendListViewController()
        )
        
        viewControllers = [friends, chats]
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
    }
    
    func templateNavigationController(unselectedImage: UIImage?, selectedImage: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        // 탭바의 뷰컨트롤러로 들어갈 UINavigationController를 생성 -> 탭바의 컨트롤러 각각은 UINavigationController임
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        // UINavigationBarAppearance를 설정해야 NavBar의 background를 지정할 수 있음
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
        return nav
    }


}

//MARK: - AuthResultDelegate
extension MainTabViewController: AuthResultDelegate {
    // LoginViewController에서 로그인 시 delegate 패턴으로 User 데이터를 전달 받음
    func result(user: User) {
        dismiss(animated: true)
        viewModel.user = user
        configureViewControllers()
        print("DEBUG login user: \(user)")
    }
}
