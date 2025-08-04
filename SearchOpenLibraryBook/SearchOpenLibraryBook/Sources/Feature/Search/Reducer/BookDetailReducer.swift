//
//  BookDetailReducer.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 8/3/25.
//

import Foundation

final class BookDetailReducer: ReducerProtocol {
    
    // MARK: - State
    
    struct State: Equatable {
        var book: Book
    }
    
    // MARK: - Action
    
    enum Action {
        case onTapOpenSafariButton
    }
    
    // MARK: - Properties
    
    let initialState: State
    private let coordinator: Coordinator
    
    // MARK: - Initializer
    
    init(
        book: Book,
        coordinator: Coordinator
    ) {
        self.initialState = .init(book: book)
        self.coordinator = coordinator
    }
    
    // MARK: - Reduce
    
    func reduce(state: inout State, action: Action) -> Effect {
        switch action {
        case .onTapOpenSafariButton:
            let url = URL(string: state.book.pageURL)!
            coordinator.present(sheet: .safari(url: url))
        }
        
        return .none
    }
}
