//
//  SearchEndpoint.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 7/30/25.
//

import Foundation

enum SearchEndpoint {
    
    /// 도서 검색
    case searchBook(query: String)
}

extension SearchEndpoint: BaseEndpoint {
    
    var urlPath: String {
        switch self {
        case .searchBook:
            return "/search.json"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .searchBook(query):
            return ["q": query]
        }
    }
    
    var body: [String : Any]? {
        return .none
    }
}
