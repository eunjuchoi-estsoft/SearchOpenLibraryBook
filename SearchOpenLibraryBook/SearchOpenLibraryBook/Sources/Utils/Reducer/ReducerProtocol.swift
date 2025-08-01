//
//  ReducerProtocol.swift
//  SearchOpenLibraryBook
//
//  Created by eunjuchoi on 7/30/25.
//

import Foundation

protocol ReducerProtocol {
    associatedtype State
    associatedtype Action
    
    typealias Effect = EffectType<Action>
    
    var initialState: State { get }
    
    func reduce(state: inout State, action: Action) -> Effect
}

/// 다른 액션을 트리거하는 Side Effect
public enum EffectType<Action> {
    case task(operation: @Sendable () async -> Action)
    case none
}
