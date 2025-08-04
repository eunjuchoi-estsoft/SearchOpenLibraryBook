//
//  SafariView.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 8/3/25.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {

    // MARK: - Properties
    
    private let url: URL
    
    // MARK: - Initializer
    
    init(url: URL) {
        self.url = url
    }

    // MARK: - Public Methods
    
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<SafariView>
    ) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(
        _ uiViewController: SFSafariViewController,
        context: UIViewControllerRepresentableContext<SafariView>
    ) {

    }
}
