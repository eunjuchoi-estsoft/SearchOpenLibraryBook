//
//  NetworkConstants.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 7/29/25.
//

import Foundation

enum HeaderType {
    case basic
    case custom([String: String])
}

enum HTTPHeaderField: String {
    case contentType = "Content-Type"
}

enum ContentType: String {
    case json = "application/json"
}

enum HTTPTask {
    case query(_ query: [String: Any])
    case queryBody(_ query: [String: Any], _ body: [String: Any])
    case requestBody(_ body: [String: Any])
    case requestPlain
}
