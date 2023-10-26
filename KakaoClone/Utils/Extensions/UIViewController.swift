//
//  UIViewController.swift
//  KakaoClone
//
//  Created by 이은재 on 10/26/23.
//

import UIKit

extension UIViewController {
    
    func showAlert(
        title: String,
        message: String,
        actions: [UIAlertAction]
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach(alert.addAction(_:))
        self.present(alert, animated: true)
    }
    
}
