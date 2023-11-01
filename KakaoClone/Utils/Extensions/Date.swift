//
//  Date.swift
//  KakaoClone
//
//  Created by 이은재 on 10/31/23.
//

import Foundation
extension Date {
    func formattedDateString(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR") // 한국 로케일 설정
        dateFormatter.dateFormat = dateFormat // 출력 형식 설정
        
        return dateFormatter.string(from: self)
    }
}
