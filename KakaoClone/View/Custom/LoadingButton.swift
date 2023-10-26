//
//  LoadingButton.swift
//  KakaoClone
//
//  Created by 이은재 on 10/26/23.
//

import UIKit

final class LoadingButton: UIButton {
    var spinner = UIActivityIndicatorView()
    var isLoading = false {
        didSet {
            updateView()
        }
    }
    var originalBackgroundColor: UIColor?
    
    init() {
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        spinner.hidesWhenStopped = true
        spinner.color = .systemGray3
        spinner.style = .medium
        
        addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func updateView() {
        if isLoading {
            spinner.startAnimating()
            titleLabel?.alpha = 0
            isEnabled = false // 중복 터치 방지
            backgroundColor = .systemGroupedBackground
        } else {
            spinner.stopAnimating()
            titleLabel?.alpha = 1
            isEnabled = true
            backgroundColor = originalBackgroundColor
        }
    }
}
