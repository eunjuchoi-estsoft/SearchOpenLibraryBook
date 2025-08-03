//
//  NetworkError.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 7/29/25.
//

import Foundation

enum NetworkError: Error {
    case invalidStatusCode(Int)
    case invalidURL
    case parsingError
    case serverError
}
