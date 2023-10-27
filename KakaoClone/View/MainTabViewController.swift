//
//  MainTabViewController.swift
//  KakaoClone
//
//  Created by 이은재 on 10/27/23.
//

import UIKit

class MainTabViewController: UITabBarController {
    //MARK: - Properties

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewControllers()
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
