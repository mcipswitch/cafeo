//
//  ViewStore+Extension.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-03-16.
//

import ComposableArchitecture
import SwiftUI

extension ViewStore {
    func binding<Value>(
        keyPath: WritableKeyPath<State, Value>,
        send action: @escaping (FormAction<State>) -> Action
    ) -> Binding<Value> where Value: Hashable {
        self.binding(
            get: { $0[keyPath: keyPath] },
            send: { action(.init(keyPath, $0)) }
        )
    }
}
