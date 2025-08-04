//
//  ViewFactory.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 8/4/25.
//

import SwiftUI

/// View를 생성하는 책임을 가지는 객체
struct ViewFactory {
    
    @MainActor @ViewBuilder static func build(scene: AppScene, coordinator: Coordinator) -> some View {
        switch scene {
        case .searchMain:
            let router = NetworkRouter()
            let networkProvider = NetworkProvider<SearchEndpoint>(router: router)
            let service = SearchServiceImpl(provider: networkProvider)
            let reducer = SearchMainReducer(service: service, coordinator: coordinator)
            let store = Store(reducer: reducer)
            SearchMainView(store: store)
            
        case let .bookDetail(book):
            let reducer = BookDetailReducer(book: book, coordinator: coordinator)
            let store = Store(reducer: reducer)
            BookDetailView(store: store)
            
        case let .safari(url):
            SafariView(url: url)
        }
    }
}
