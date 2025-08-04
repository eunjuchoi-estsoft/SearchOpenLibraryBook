//
//  Coordinator.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 8/4/25.
//

import SwiftUI

protocol Coordinator {
    var path: NavigationPath { get set }
    var sheet: AppScene? { get set }
    var initialScene: AppScene { get set }
    
    func push(_ scene: AppScene)
    func pop()
    func popToRoot()
    func present(sheet: AppScene)
    func dismiss()
}
