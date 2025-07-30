//
//  SearchEndpoint.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 7/30/25.
//

import Foundation

public enum SearchEndpoint {
    
    /// 도서 검색
    case searchBook(query: String)
}

extension SearchEndpoint: BaseEndpoint {
    
    public var urlPath: String {
        switch self {
        case .searchBook:
            return "/search.json"
        }
    }
    
    public var method: HTTPMethod {
        return .get
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case let .searchBook(query):
            return ["q": query]
        }
    }
    
    public var body: [String : Any]? {
        return .none
    }
}
