//
//  Book.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 7/30/25.
//

import Foundation

struct Book: Hashable, Identifiable {
    let id = UUID()
    let title: String
    let authors: [String]?
    let firstPublishYear: Int?
    let languages: [String]?
    let thumbnailURL: String?
    let pageURL: String
}
