//
//  BaseEndpoint.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 7/29/25.
//

import Foundation

public protocol BaseEndpoint: EndpointType {
    var urlPath: String { get }
    var parameters: [String: Any]? { get }
    var body: [String: Any]? { get }
}

extension BaseEndpoint {
    var baseURL: URL {
        return URL(string: NetworkEnvironment.baseURL)!
    }
    
    var path: String {
        return urlPath
    }
    
    var task: HTTPTask {
        if let parameters = parameters {
            if let body = body {
                return .queryBody(parameters, body)
            }
            return .query(parameters)
        }
        
        if let body = body {
            return .requestBody(body)
        }
        
        return .requestPlain
    }
    
    var header: HeaderType {
        return .basic
    }
}
