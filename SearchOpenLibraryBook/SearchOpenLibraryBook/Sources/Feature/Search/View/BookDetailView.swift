//
//  BookDetailView.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 7/31/25.
//

import SwiftUI

struct BookDetailView: View {
    
    // MARK: - Properties
    
    @StateObject private var store: Store<BookDetailReducer>
    
    // MARK: - Initializer
    
    init(store: Store<BookDetailReducer>) {
        self._store = .init(wrappedValue: store)
    }
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                
                // 책 표지 이미지
                BookCoverView(
                    urlString: store.state.book.thumbnailURL,
                    width: .infinity,
                    height: 450
                )
                .padding(.horizontal, 30)
                
                // 책 정보
                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .top, spacing: 0) {
                        Text("제목: ")
                            .font(.system(size: 24, weight: .semibold))
                        Text(store.state.book.title)
                            .font(.system(size: 24, weight: .regular))
                    }
                    HStack(alignment: .top, spacing: 0) {
                        Text("저자: ")
                            .font(.system(size: 24, weight: .semibold))
                        Text(store.state.book.authors?.joined(separator: ", ") ?? "정보없음")
                            .font(.system(size: 24, weight: .regular))
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                // Safari로 이동 버튼
                Button(action: {
                    store.send(.onTapOpenSafariButton)
                }, label: {
                    HStack {
                        SystemImage.book.image
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.black)
                        
                        Text("OpenLibrary에서 보기")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.black)
                    }
                    .frame(maxWidth: .infinity)
                })
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 1)
                )
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            }
        }
    }
}

#Preview {
    let book = Book(title: "Ff (The Alphabet)", authors: ["George S. Clason"], firstPublishYear: 2023, languages: [], thumbnailURL: "https://covers.openlibrary.org/b/id/14558369-M.jpg", pageURL: "")
    let router = NetworkRouter()
    let provider = NetworkProvider<SearchEndpoint>(router: router)
    let service = SearchServiceImpl(provider: provider)
    let reducer = BookDetailReducer(book: book, coordinator: MainCoordinator(.searchMain))
    let store = Store(reducer: reducer)
    BookDetailView(store: store)
}
