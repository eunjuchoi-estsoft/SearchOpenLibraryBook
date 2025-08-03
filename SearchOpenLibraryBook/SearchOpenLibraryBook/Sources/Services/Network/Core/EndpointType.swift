//
//  EndpointType.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 7/29/25.
//

import Foundation

protocol EndpointType {
    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var task: HTTPTask { get }
    var header: HeaderType { get }
}

// MARK: - Private Methods

extension EndpointType {
    
    private func makeHeader(for request: URLRequest) -> URLRequest {
        var request = request
        
        switch header {
        case .basic:
            request.setValue(ContentType.json.rawValue,
                             forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        case let .custom(headers):
            headers.forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return request
    }
    
    private func makeParameter(for request: URLRequest, with url: URL) throws -> URLRequest {
        var request = request
        
        switch task {
        case let .query(query):
            let queryParams = query.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            request.url = components?.url
            
        case let .queryBody(query, body):
            let queryParams = query.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            request.url = components?.url
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            
        case let .requestBody(body):
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            
        case .requestPlain:
            break
        }
        
        return request
    }
}

// MARK: - Public Methods

extension EndpointType {
    
    func creatURLRequest() throws -> URLRequest {
        let url = baseURL
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest = self.makeHeader(for: urlRequest)
        
        return try makeParameter(for: urlRequest, with: url)
    }
}
