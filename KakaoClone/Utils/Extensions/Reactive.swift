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
}
