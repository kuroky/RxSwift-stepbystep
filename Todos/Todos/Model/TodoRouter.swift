//
//  TodoRouter.swift
//  Todos
//
//  Created by kuroky on 2018/12/28.
//  Copyright © 2018 Kuroky. All rights reserved.
//

import UIKit
import Alamofire

enum TodoRouter {
    static let baseURL: String = "https://jsonplaceholder.typicode.com/"
    
    case get(Int?)
}

extension TodoRouter: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .get:
                return .get
            }
        }
        
        var params: [String: Any]? {
            switch self {
            case .get:
                return nil
            }
        }
        
        var url: URL {
            var relativeUrl: String = "todos"
            
            switch self {
            case .get(let todoId):
                if todoId != nil {
                    relativeUrl = "todos/\(todoId!)"
                }
            }
            let url = URL(string: TodoRouter.baseURL)!.appendingPathComponent(relativeUrl)
            return url
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        let encoding = JSONEncoding.default
        
        return try encoding.encode(request, with: params)
    }
}

