//
//  SearchView.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 7/30/25.
//

import SwiftUI

struct SearchView: View {
    
    // MARK: - Properties
    
    private let placeholder: String
    @Binding private var searchText: String
    private let onTapSearchButton: (() -> Void)
    @State private var isSearchTextEmpty: Bool = false
    
    // MARK: - Initializer
    
    init(
        placeholder: String,
        searchText: Binding<String>,
        onTapSearchButton: @escaping (() -> Void) = {},
    ) {
        self.placeholder = placeholder
        self._searchText = searchText
        self.onTapSearchButton = onTapSearchButton
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                
                // 검색 입력 필드
                TextField(placeholder, text: $searchText)
                    .font(.system(size: 15, weight: .medium))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(.white)
                    .submitLabel(.search)
                    .onSubmit {
                        onTapSearchButton()
                    }
                
                // 구분선
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 1.5)
                
                // 검색 버튼
                Button(action: {
                    onTapSearchButton()
                    isSearchTextEmpty = searchText.isEmpty
                }) {
                    SystemImage.chevronRight.image
                        .foregroundStyle(.black)
                        .font(.system(size: 20, weight: .regular))
                        .frame(width: 40, height: 40)
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.black, lineWidth: 1.5)
            )
            .frame(height: 44)
            
            // 검색어 없음 경고
            HStack(spacing: 4) {
                SystemImage.exclamationmarkCircle.image
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(isSearchTextEmpty ? .red : .clear)
                    .frame(width: 12, height: 12)
                
                Text("검색어를 입력해주세요")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(isSearchTextEmpty ? .red : .clear)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 5)
        }
    }
}

#Preview {
    @State var searchText: String = ""
    
    SearchView(
        placeholder: "검색어를 입력해주세요",
        searchText: $searchText
    ) {
        
    }
    .padding(.horizontal, 16)
}
