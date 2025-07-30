//
//  SearchError.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 7/29/25.
//

import Foundation

public enum SearchError: Int, Error {
    case invalidURL = 400
    case forbidden = 403
    case notFound = 404
    case serverError = 500
    case parsingFailed
    
    public var message: String {
        switch self {
        case .invalidURL:
            "잘못된 요청입니다. 다시 시도해주세요."
        case .forbidden:
            "요청 횟수를 초과했습니다. 잠시 후 다시 시도해주세요."
        case .notFound:
            "이미지를 찾을 수 없습니다. 다른 검색어로 시도해주세요."
        case .serverError:
            "네트워크에 문제가 발생하였습니다. 잠시 후 다시 시도해주세요."
        case .parsingFailed:
            "데이터 처리 중 오류가 발생했습니다. 문제가 계속될 경우 관리자에게 문의해주세요."
        }
    }
}
