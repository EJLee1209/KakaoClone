//
//  String.swift
//  KakaoClone
//
//  Created by 이은재 on 11/5/23.
//

import Foundation

extension String {
    
    func makePrettyDateTime() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let date = inputFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "ko_KR") // 한국어로 출력하기 위한 로케일 설정
            outputFormatter.dateFormat = "a h:mm"

            let output = outputFormatter.string(from: date)
            return output
        } else {
            return "오전 00:00"
        }
    }
    
}
