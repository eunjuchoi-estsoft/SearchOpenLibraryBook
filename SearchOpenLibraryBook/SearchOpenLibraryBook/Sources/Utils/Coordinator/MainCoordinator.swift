//
//  MainCoordinator.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 8/4/25.
//

import SwiftUI

final class MainCoordinator: ObservableObject, Coordinator {
    
    // MARK: - Properties
    
    @Published var path: NavigationPath
    @Published var sheet: AppScene?
    var initialScene: AppScene
    
    // MARK: - Initializer
    
    init(_ initialScene: AppScene) {
        self.path = NavigationPath()
        self.initialScene = initialScene
    }
    
    // MARK: - Public Methods
    
    func push(_ scene: AppScene) {
        path.append(scene)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func present(sheet: AppScene) {
        self.sheet = sheet
    }
    
    func dismiss() {
        self.sheet = nil
    }
}
