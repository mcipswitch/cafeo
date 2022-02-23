//
//  AppState+Helpers.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-13.
//

import SwiftUI

//// MARK: - FormAction
//
///// Please see: https://www.pointfree.co/episodes/ep133-concise-forms-bye-bye-boilerplate
//struct FormAction<Root>: Equatable {
//    let keyPath: PartialKeyPath<Root>
//    let value: AnyHashable
//    let setter: (inout Root) -> Void
//
//    init<Value>(
//        _ keyPath: WritableKeyPath<Root, Value>,
//        _ value: Value
//    ) where Value: Hashable {
//        self.keyPath = keyPath
//        self.value = value
//        self.setter = { $0[keyPath: keyPath] = value }
//    }
//
//    static func set<Value>(
//        _ keyPath: WritableKeyPath<Root, Value>,
//        _ value: Value
//    ) -> Self where Value: Hashable {
//        .init(keyPath, value)
//    }
//
//    static func == (lhs: FormAction<Root>, rhs: FormAction<Root>) -> Bool {
//        lhs.keyPath == rhs.keyPath && lhs.value == rhs.value
//    }
//}
//
//func ~= <Root, Value> (
//    keyPath: WritableKeyPath<Root, Value>,
//    formAction: FormAction<Root>
//) -> Bool {
//    formAction.keyPath == keyPath
//}

// MARK: - Enum Helpers

enum IngredientAction {
    case increment
    case decrement
}

enum CafeoIngredient: String, Codable {
    case coffee
    case water
}

enum CafeoUnit: String, Codable {
    case grams
    case ounces
}

// MARK: - CafeoUnit + Extension

extension CafeoUnit {
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
