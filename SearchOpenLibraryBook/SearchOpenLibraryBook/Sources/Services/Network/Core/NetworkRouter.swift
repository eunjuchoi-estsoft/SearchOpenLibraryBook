//
//  NetworkRouter.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 7/29/25.
//

import Foundation

protocol Routable {
    func request<T: Decodable>(with endpoint: EndpointType) async throws -> T
}

public final class NetworkRouter: Routable {
    private let session: URLSession
    private let decoder = JSONDecoder()
    
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    public func request<T: Decodable>(with endpoint: EndpointType) async throws -> T {
        guard let urlRequest = try? endpoint.creatURLRequest()
        else {
            throw NetworkError.invalidURL
        }
        
        let data = try await requestData(with: urlRequest)
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.parsingError
        }
    }
}

// MARK: - Private Methods

extension NetworkRouter {
    
    private func requestData(with urlRequest: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.serverError
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidStatusCode(httpResponse.statusCode)
        }

        return data
    }
}
