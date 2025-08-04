//
//  BookCoverView.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 8/3/25.
//

import SwiftUI

struct BookCoverView: View {
    
    // MARK: - Properties
    
    private let urlString: String?
    private let width: CGFloat
    private let height: CGFloat
    
    // MARK: - Initializer
    
    init(
        urlString: String?,
        width: CGFloat = 100,
        height: CGFloat = 100
    ) {
        self.urlString = urlString
        self.width = width
        self.height = height
    }
    
    // MARK: - Body
    
    var body: some View {
        if let urlString = urlString,
           let url = URL(string: urlString) {
            CachedAsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: width)
                    .frame(height: height)
            } placeholder: {
                Rectangle()
                    .fill(Color(uiColor: .systemGray4))
                    .frame(maxWidth: width)
                    .frame(height: height)
                    .overlay {
                        LoadingView(scaleSize: 0.5 * (height / 100))
                    }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.vertical, 10)
        } else {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(uiColor: .systemGray5))
                .frame(maxWidth: width)
                .frame(height: height)
                .overlay {
                    SystemImage.bookClosed.image
                        .font(.system(size: 20 * (height / 100)))
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 10)
        }
    }
}
