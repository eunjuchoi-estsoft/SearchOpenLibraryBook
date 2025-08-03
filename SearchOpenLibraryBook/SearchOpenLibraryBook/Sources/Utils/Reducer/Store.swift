//
//  Store.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 7/30/25.
//

import Foundation

/// Reducer 를 관리하는 Store
@MainActor
final class Store<Reducer: ReducerProtocol>: ObservableObject {
    
    // MARK: - Properties
    
    @Published private(set) var state: Reducer.State
    private let reducer: Reducer
    private var tasks: Set<Task<(), Never>> = []

    // MARK: - Initializer
    
    init(reducer: Reducer) {
        self.reducer = reducer
        self.state = reducer.initialState
    }
    
    // MARK: - Deinitializer
    
    deinit {
        tasks.forEach { $0.cancel() }
    }

    // MARK: - Public Methods
    
    func send(_ action: Reducer.Action) {
        send(&state, action)
    }

    // MARK: - Private Methods

    private func send(_ state: inout Reducer.State, _ action: Reducer.Action) {
        let effect = reducer.reduce(state: &state, action: action)

        switch effect {
        case let .task(operation):
            let newTask = Task {
                let nextAction = await operation()
                send(nextAction)
            }
            tasks.insert(newTask)

        case .none:
            break
        }
    }
}

