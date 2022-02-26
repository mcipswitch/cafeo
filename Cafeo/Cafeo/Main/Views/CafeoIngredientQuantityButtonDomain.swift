//
//  CafeoIngredientQuantityButtonDomain.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2022-02-23.
//

import ComposableArchitecture
import Foundation

struct CafeoIngredientQuantityButtonDomain {

    struct State: Equatable {}

    enum Action: Equatable {
        case onPress(step: IngredientAction)
        case onRelease
        case onTap(step: IngredientAction)
    }

    struct Environment {}

    static let reducer: Reducer<State, Action, Environment> = {
        return .init { state, action, env in
            switch action {
            default:
                return .none
            }
        }
    }()
}
