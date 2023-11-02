//
//  Reactive+.swift
//  KakaoClone
//
//  Created by 이은재 on 10/26/23.
//

import UIKit
import RxSwift

extension Reactive where Base: UIButton {
    var loginButtonEnabled: Binder<Bool> {
        return Binder(self.base) { button, enabled in
            button.isEnabled = enabled
            button.backgroundColor = enabled ? .systemYellow : .systemGroupedBackground
        }
    }
    
    var editButtonIsEnabled: Binder<String?> {
        return .init(self.base) { button, text in
            guard let text = text else { return }
            button.isEnabled = !text.isEmpty
        }
    }
    
    var sendButtonIsHidden: Binder<String?> {
        return Binder(self.base) { button, text in
            guard let text = text else { return }
            button.isHidden = text.isEmpty
        }
    }
}
