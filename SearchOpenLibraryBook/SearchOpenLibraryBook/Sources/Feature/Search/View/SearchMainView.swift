//
//  SearchMainView.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 7/30/25.
//

import SwiftUI

struct SearchMainView: View {
    
    // MARK: - Properties
    
    @State private var navigationPath = NavigationPath()
    @StateObject private var store: Store<SearchMainReducer>
    
    // MARK: - Initializer
    
    init(store: Store<SearchMainReducer>) {
        self._store = .init(wrappedValue: store)
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 0) {
                SearchView(
                    placeholder: "도서 제목이나 저자명으로 검색해보세요",
                    searchText:
                        Binding(
                            get: { store.state.searchText },
                            set: { store.send(.onChange(searchText: $0)) }
                        )
                ) {
                    store.send(.onTapSearchButton)
                }
                .padding(.top, 10)
                .padding(.horizontal, 24)
                
                resultView()
                    .background(Color(uiColor: .systemGray4))
            }
            .alert(store.state.errorTitle,
                   isPresented: Binding(
                    get: { store.state.isAlertPresented },
                    set: { _ in store.send(.dismissAlert) }
                   )
            ) {
                Button("확인", role: .cancel) {}
            } message: {
                Text(store.state.errorMessage)
            }
            .navigationTitle("도서 검색")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Book.self) { book in
                BookDetailView()
            }
        }
    }
}

// MARK: - Private Methods

extension SearchMainView {
    
    @ViewBuilder private func resultView() -> some View {
        switch store.state.searchResultViewState {
        case .initial:
            EmptyResultView(
                image: SystemImage.magnifyingglass.image,
                title: "검색어를 입력해주세요",
                message: "찾고 싶은 도서 제목으로 검색해보세요"
            )
            
        case .hasResult:
            bookListView()
            
        case .hasNoResult:
            EmptyResultView(
                image: SystemImage.magnifyingglass.image,
                title: "\"\(store.state.lastSearchText)\"에 대한 검색결과가 없습니다.",
                message: "다른 검색어로 다시 시도해보세요"
            )
            
        case .isLoading:
            LoadingView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private func bookListView() -> some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(store.state.books, id: \.id) { book in
                    BookCardView(book: book) {
                        store.send(.onTapPushDetailButton(book))
                    }
                }
            }
        }
    }
}

#Preview {
    let router = NetworkRouter()
    let provider = NetworkProvider<SearchEndpoint>(router: router)
    let service = SearchServiceImpl(provider: provider)
    let reducer = SearchMainReducer(service: service)
    let store = Store(reducer: reducer)
    SearchMainView(store: store)
}
