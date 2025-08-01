//
//  ImageConstants.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 8/1/25.
//

import SwiftUI

/// 시스템 이미지 이름을 관리하는 열거형
enum SystemImage: String, CaseIterable {
    case chevronUp = "chevron.up"
    case chevronDown = "chevron.down"
    case heart = "heart.fill"
    case magnifyingglass = "magnifyingglass"
    case exclamationmarkCircle = "exclamationmark.circle"
    
    var image: Image {
        Image(systemName: self.rawValue)
    }
}

/// 번들 이미지 이름을 관리하는 열거형
enum AppImage: String, CaseIterable {
    case heart = "heart.fill"
    
    var image: Image {
        Image(self.rawValue)
    }
}
