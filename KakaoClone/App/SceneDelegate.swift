//
//  SceneDelegate.swift
//  KakaoClone
//
//  Created by 이은재 on 10/26/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
//        let authService = AuthService()
//        let loginVM = LoginViewModel(authService: authService)
//        let vc = LoginViewController(viewModel: loginVM)
//        let nav = UINavigationController(rootViewController: vc)
        
        let mainTab = MainTabViewController()
        
        window.rootViewController = mainTab
        self.window = window
        self.window?.makeKeyAndVisible()
    }
}

