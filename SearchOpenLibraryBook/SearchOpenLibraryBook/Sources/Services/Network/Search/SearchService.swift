//
//  SearchService.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 7/30/25.
//

import Foundation

// MARK: - SearchService

protocol SearchService {
    func fetchBookList(with query: String) async throws -> [Book]
}

// MARK: - SearchServiceImpl

final class SearchServiceImpl: SearchService {
    
    // MARK: - Properties
    
    typealias Endpoint = SearchEndpoint
    
    private let provider: NetworkProvider<Endpoint>
    
    // MARK: - Initializer
    
    init(
        provider: NetworkProvider<Endpoint>
    ) {
        self.provider = provider
    }
    
    // MARK: - Public Methods
    
    func fetchBookList(with query: String) async throws -> [Book] {
        let response: SearchBookResponse = try await provider.request(with: .searchBook(query: query))
        return response.toEntity()
    }
}
