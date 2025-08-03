//
//  EmptyResultView.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 7/30/25.
//

import SwiftUI

struct EmptyResultView: View {
    
    // MARK: - Properties
    
    private let image: Image
    private let title: String
    private let message: String
    
    // MARK: Initializer
    
    init(
        image: Image,
        title: String,
        message: String
    ) {
        self.image = image
        self.title = title
        self.message = message
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            image
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding(.bottom, 10)
            
            Text(title)
                .font(.system(size: 20, weight: .semibold))
                .multilineTextAlignment(.center)
                .padding(.bottom, 1)
            
            Text(message)
                .font(.system(size: 16, weight: .regular))
                .multilineTextAlignment(.center)
                .foregroundStyle(.gray)
        }
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyResultView(
        image: SystemImage.heart.image,
        title: "검색 결과 없음",
        message: "다른 검색어로 다시 시도해주세요"
    )
}
