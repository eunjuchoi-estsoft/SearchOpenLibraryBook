//
//  BookCardView.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 7/30/25.
//

import SwiftUI

struct BookCardView: View {
    
    // MARK: - Properties
    
    @State private var book: Book
    @State private var isExpanded: Bool = false
    private let onTapShowDetailButton: (() -> Void)
    
    // MARK: - Initializer
    
    init(
        book: Book,
        onTapShowDetailButton: @escaping (() -> Void) = {}
    ) {
        self.book = book
        self.onTapShowDetailButton = onTapShowDetailButton
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 15) {
                
                // 책 표지 이미지
                BookCoverView(
                    urlString: book.thumbnailURL,
                    width: 100,
                    height: 130
                )
                
                // 책 정보
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(book.title)
                                .font(.system(size: 20, weight: .semibold))
                                .lineLimit(2)
                            HStack(alignment: .top, spacing: 0) {
                                Text("저자: ")
                                    .font(.system(size: 15, weight: .semibold))
                                Text(book.authors?.joined(separator: ", ") ?? "정보없음")
                                    .font(.system(size: 15, weight: .regular))
                                    .lineLimit(2)
                            }
                            
                            // 펼쳐졌을 때만 표시되는 추가 정보
                            DetailBookInfoView(
                                isHidden: Binding(
                                    get: { !isExpanded },
                                    set: { isExpanded = !$0 }
                                ),
                                book: book
                            )
                            .transition(.opacity.combined(with: .scale(scale: 0.95)))
                        }
                        .padding(.leading, 10)
                        Spacer()
                    }
                    
                    Spacer()
                    
                    // 오른쪽 아래 펼치기 버튼
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                isExpanded.toggle()
                            }
                        }) {
                            HStack(spacing: 3) {
                                (isExpanded ? SystemImage.chevronUp.image : SystemImage.chevronDown.image)
                                    .foregroundStyle(.black)
                                    .font(.system(size: 10, weight: .medium))
                                Text(isExpanded ? "접기" : "펼치기")
                                    .foregroundStyle(.black)
                                    .font(.system(size: 12, weight: .medium))
                            }
                            .padding(5)
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.cyan)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 10)
                .padding(.top, 20)
                .padding(.bottom, 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 1)
                )
                .padding(.vertical, 10)
            }
            .padding(.horizontal, 20)
            
            // 상세보기 버튼
            Button(action: {
                onTapShowDetailButton()
            }, label: {
                Text("상세보기")
                    .foregroundStyle(.black)
                    .font(.system(size: 14, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            })
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
        .background(.white)
        .frame(maxWidth: .infinity)
    }
}

fileprivate struct DetailBookInfoView: View {
    @Binding var isHidden: Bool
    private let book: Book
    
    init(
        isHidden: Binding<Bool>,
        book: Book
    ) {
        self._isHidden = isHidden
        self.book = book
    }
    
    var body: some View {
        if !isHidden {
            HStack(alignment: .top, spacing: 0) {
                Text("출간년도: ")
                    .font(.system(size: 15, weight: .semibold))
                Text(book.firstPublishYear.map { String($0) } ?? "정보없음")
                    .font(.system(size: 15, weight: .regular))
                    .lineLimit(1)
            }
            
            HStack(alignment: .top, spacing: 0) {
                Text("언어: ")
                    .font(.system(size: 15, weight: .semibold))
                Text(book.languages?.joined(separator: ", ") ?? "정보없음")
                    .font(.system(size: 15, weight: .regular))
                    .lineLimit(1)
            }
        }
    }
}

#Preview {
    BookCardView(book: Book(title: "", authors: nil, firstPublishYear: 2024, languages: ["kor", "eng"], thumbnailURL: "", pageURL: ""))
        .frame(height: 200)
}
