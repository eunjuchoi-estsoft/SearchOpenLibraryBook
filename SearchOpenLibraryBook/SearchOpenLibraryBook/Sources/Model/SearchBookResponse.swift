//
//  SearchBookResponse.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 7/30/25.
//

import Foundation

// MARK: - SearchBookResponse

struct SearchBookResponse: Decodable {
    let numFound: Int
    let start: Int
    let numFoundExact: Bool
    let bookNumFound: Int
    let documentationURL: String
    let query: String
    let offset: Int?
    let docs: [Document]
    
    enum CodingKeys: String, CodingKey {
        case numFound, start, numFoundExact
        case bookNumFound = "num_found"
        case documentationURL = "documentation_url"
        case query = "q"
        case offset, docs
    }
}

// MARK: - Document

struct Document: Decodable {
    let authorKey: [String]?
    let authorName: [String]?
    let coverEditionKey: String?
    let coverId: Int?
    let ebookAccess: String?
    let editionCount: Int?
    let firstPublishYear: Int?
    let hasFulltext: Bool?
    let ia: [String]?
    let iaCollectionS: String?
    let key: String
    let language: [String]?
    let lendingEditionS: String?
    let lendingIdentifierS: String?
    let publicScanB: Bool?
    let title: String
    let idStandardEbooks: [String]?
    let idLibrivox: [String]?
    let subtitle: String?
    let idProjectGutenberg: [String]?
    
    enum CodingKeys: String, CodingKey {
        case authorKey = "author_key"
        case authorName = "author_name"
        case coverEditionKey = "cover_edition_key"
        case coverId = "cover_i"
        case ebookAccess = "ebook_access"
        case editionCount = "edition_count"
        case firstPublishYear = "first_publish_year"
        case hasFulltext = "has_fulltext"
        case ia
        case iaCollectionS = "ia_collection_s"
        case key
        case language
        case lendingEditionS = "lending_edition_s"
        case lendingIdentifierS = "lending_identifier_s"
        case publicScanB = "public_scan_b"
        case title
        case idStandardEbooks = "id_standard_ebooks"
        case idLibrivox = "id_librivox"
        case subtitle
        case idProjectGutenberg = "id_project_gutenberg"
    }
}

// MARK: - Public Methods

extension SearchBookResponse {
    
    func toEntity() -> [Book] {
        return docs.map {
            Book(
                title: $0.title,
                authors: $0.authorName,
                firstPublishYear: $0.firstPublishYear,
                languages: $0.language,
                thumbnailURL: $0.coverId.map { "\(NetworkEnvironment.bookCoverURL)/\($0)-M.jpg" },
                pageURL: "\(NetworkEnvironment.baseURL)\($0.key)"
            )
        }
    }
}
