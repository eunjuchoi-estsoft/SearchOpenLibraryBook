//
//  SearchOpenLibraryBookApp.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 7/29/25.
//

import SwiftUI

@main
struct SearchOpenLibraryBookApp: App {
    var body: some Scene {
        WindowGroup {
            let router = NetworkRouter()
            let networkProvider = NetworkProvider<SearchEndpoint>(router: router)
            let service = SearchServiceImpl(provider: networkProvider)
            let reducer = SearchMainReducer(service: service)
            let store = Store(reducer: reducer)
            SearchMainView(store: store)
        }
    }
}
