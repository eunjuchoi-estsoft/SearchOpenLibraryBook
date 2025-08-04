//
//  CachedAsyncImage.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 8/4/25.
//

import SwiftUI

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    
    // MARK: - Properties
    
    @State private var image: Image? = nil
    @State private var isLoading = false
    
    private let url: URL?
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder
    
    // MARK: - Initializer
    
    init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }
    
    // MARK: - Body
    
    var body: some View {
        if let image = image {
            content(image)
        } else {
            placeholder()
                .onAppear {
                    Task {
                        await loadImage()
                    }
                }
        }
    }
}

// MARK: - Private Methods

extension CachedAsyncImage {
    
    private func loadImage() async {
        guard let url = url, !isLoading else { return }
        
        isLoading = true
        
        // 캐시 확인
        let request = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: request),
           let cachedImage = UIImage(data: cachedResponse.data) {
            await MainActor.run {
                self.image = Image(uiImage: cachedImage)
                self.isLoading = false
            }
            return
        }
        
        // 캐시에 저장된 이미지 없다면 네트워크에서 이미지 다운로드
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Cache the image
            let cachedData = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cachedData, for: request)
            
            if let uiImage = UIImage(data: data) {
                await MainActor.run {
                    self.image = Image(uiImage: uiImage)
                    self.isLoading = false
                }
            }
        } catch {
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
}

// MARK: - Initializers

extension CachedAsyncImage {
    
    /// 기본값이 모두 정의되어있는 가장 간단한 이니셜라이저
    init(url: URL?) where Content == AnyView, Placeholder == ProgressView<EmptyView, EmptyView> {
        self.url = url
        self.content = { image in
            AnyView(
                image
                    .resizable()
                    .scaledToFit()
            )
        }
        self.placeholder = { ProgressView() }
    }
    
    /// 기본 placeholder가 적용된 content를 외부에서 적용하는 이니셜라이저
    init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> Content
    ) where Placeholder == ProgressView<EmptyView, EmptyView> {
        self.url = url
        self.content = content
        self.placeholder = { ProgressView() }
    }
}
