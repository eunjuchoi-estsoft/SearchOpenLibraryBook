//
//  AppScene.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 8/4/25.
//

import Foundation

enum AppScene: Hashable, Identifiable {
    case searchMain
    case bookDetail(book: Book)
    case safari(url: URL)
    
    var id: Self {
        return self
    }
}
