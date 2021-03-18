//
//  AppState+Helpers.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-03-13.
//

import SwiftUI

// MARK: - FormAction

struct FormAction<Root>: Equatable {
    let keyPath: PartialKeyPath<Root>
    let value: AnyHashable
    let setter: (inout Root) -> Void

    init<Value>(
        _ keyPath: WritableKeyPath<Root, Value>,
        _ value: Value
    ) where Value: Hashable {
        self.keyPath = keyPath
        self.value = value
        self.setter = { $0[keyPath: keyPath] = value }
    }

    static func set<Value>(
        _ keyPath: WritableKeyPath<Root, Value>,
        _ value: Value
    ) -> Self where Value: Hashable {
        .init(keyPath, value)
    }

    static func == (lhs: FormAction<Root>, rhs: FormAction<Root>) -> Bool {
        lhs.keyPath == rhs.keyPath && lhs.value == rhs.value
    }
}

// MARK: - Helpers

enum AdjustAmountAction {
    case increment, decrement
}

enum CoffioUnit: String, Codable {
    case grams, ounces
}

// MARK: - CoffioUnit+Extension

extension CoffioUnit {
    var abbrString: String {
        switch self {
        case .grams:
            return "gr"
        case .ounces:
            return "oz"
        }
    }

    var toggleYOffset: CGFloat {
        switch self {
        case .grams:
            return -30
        case .ounces:
            return 30
        }
    }
}
