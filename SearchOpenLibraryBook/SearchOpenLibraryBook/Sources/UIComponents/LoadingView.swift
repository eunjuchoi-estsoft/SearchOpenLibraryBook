//
//  LoadingView.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 7/31/25.
//

import SwiftUI

struct LoadingView: View {
    
    // MARK: - Properties
    
    private let tintColor: Color
    private let scaleSize: CGFloat
    
    // MARK: - Initializer
    
    init(
        tintColor: Color = .gray,
        scaleSize: CGFloat = 1.5
    ) {
        self.tintColor = tintColor
        self.scaleSize = scaleSize
    }
    
    // MARK: - Body
    
    var body: some View {
        ProgressView()
            .scaleEffect(scaleSize, anchor: .center)
            .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
    }
}

#Preview {
    LoadingView()
}
