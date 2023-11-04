//
//  Router.swift
//  KakaoClone
//
//  Created by 이은재 on 11/4/23.
//

import Foundation
import Alamofire

protocol Router {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var parameters: [String: Any]? { get }
    var encoding: ParameterEncoding? { get }
}
