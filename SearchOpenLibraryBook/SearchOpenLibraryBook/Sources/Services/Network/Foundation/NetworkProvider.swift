//
//  NetworkProvider.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 7/29/25.
//

import Foundation

public protocol Requestable {
    associatedtype Endpoint: BaseEndpoint
    
    func request<T: Decodable>(with endpoint: Endpoint) async throws -> T
}

public final class NetworkProvider<Endpoint: BaseEndpoint>: Requestable {
    private let router: NetworkRouter
    
    public init(router: NetworkRouter) {
        self.router = router
    }
    
    public func request<T: Decodable>(with endpoint: Endpoint) async throws -> T {
        do {
            return try await router.request(with: endpoint)
        } catch {
            if let networkError = error as? NetworkError {
                switch networkError {
                case let .invalidStatusCode(statusCode):
                    if let searchError = SearchError(rawValue: statusCode) {
                        throw searchError
                    }
                    throw SearchError.serverError
                case .invalidURL:
                    throw SearchError.invalidURL
                case .parsingError:
                    throw SearchError.parsingFailed
                default:
                    throw SearchError.serverError
                }
            }
            throw SearchError.serverError
        }
    }
}
