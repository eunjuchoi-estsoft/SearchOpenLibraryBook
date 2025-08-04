//
//  SearchMainReducer.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 7/30/25.
//

import Foundation

final class SearchMainReducer: ReducerProtocol {
    
    // MARK: - State
    
    struct State: Equatable {
        var searchResultViewState: SearchResultViewState = .initial
        var searchText: String = ""
        var lastSearchText: String = ""
        var books: [Book] = []
        var errorTitle: String = "네트워크 오류 발생"
        var errorMessage: String = ""
        var isAlertPresented: Bool = false
    }
    
    // MARK: - Action
    
    enum Action {
        case onChange(searchText: String)
        case onTapSearchButton
        case completeFetchBooks(result: [Book])
        case hasNetworkError(SearchError)
        case onTapPushDetailButton(Book)
        case dismissAlert
    }
    
    // MARK: - Properties
    
    let initialState: State = .init()
    private let service: SearchService
    private let coordinator: any Coordinator
    
    // MARK: - Initializer
    
    init(
        service: SearchService,
        coordinator: Coordinator
    ) {
        self.service = service
        self.coordinator = coordinator
    }
    
    // MARK: - Reduce
    
    func reduce(state: inout State, action: Action) -> Effect {
        switch action {
        case let .onChange(searchText):
            state.searchText = searchText
            
        case .onTapSearchButton:
            if !state.searchText.isEmpty {
                return searchAction(&state)
            }
            
        case let .completeFetchBooks(result):
            completeFetchAction(&state, result: result)
            
        case let .hasNetworkError(error):
            state.isAlertPresented = true
            state.errorMessage = error.message
            state.searchResultViewState = state.lastSearchText.isEmpty ? .initial : .hasResult
            
        case let .onTapPushDetailButton(book):
            coordinator.push(.bookDetail(book: book))
            
        case .dismissAlert:
            state.isAlertPresented = false
        }
        
        return .none
    }
}

// MARK: - Private Methods

extension SearchMainReducer {
    
    private func searchAction(_ state: inout State) -> Effect {
        state.searchResultViewState = .isLoading
        return searchEffect(state)
    }
    
    private func searchEffect(_ state: State) -> Effect {
        return .task { [weak self] in
            do {
                let result = try await self?.service.fetchBookList(with: state.searchText)
                return .completeFetchBooks(result: result ?? [])
            } catch {
                let searchError = error as? SearchError ?? .serverError
                return .hasNetworkError(searchError)
            }
        }
    }
    
    private func completeFetchAction(_ state: inout State, result: [Book]) {
        state.searchResultViewState = result.isEmpty ? .hasNoResult : .hasResult
        state.books = result
        state.lastSearchText = state.searchText
    }
}

extension SearchMainReducer.State {
    
    /// 검색 결과 화면의 상태를 나타내는 열거형
    enum SearchResultViewState: Equatable {
        case initial
        case isLoading
        case hasResult
        case hasNoResult
    }
}
