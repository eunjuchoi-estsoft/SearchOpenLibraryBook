//
//  SearchOpenLibraryBookApp.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 7/29/25.
//

import SwiftUI

@main
struct SearchOpenLibraryBookApp: App {
    @StateObject private var coordinator = MainCoordinator(.searchMain)

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                ViewFactory.build(scene: coordinator.initialScene, coordinator: coordinator)
                    .navigationDestination(for: AppScene.self) { scene in
                        ViewFactory.build(scene: scene, coordinator: coordinator)
                    }
                    .sheet(item: $coordinator.sheet) { scene in
                        ViewFactory.build(scene: scene, coordinator: coordinator)
                    }
            }
        }
    }
}
