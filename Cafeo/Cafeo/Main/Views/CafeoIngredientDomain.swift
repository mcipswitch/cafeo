//
//  CafeoIngredientAmountDomain.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-07-18.
//

import ComposableArchitecture
import SwiftUI

struct CafeoIngredientDomain {

    struct State: Equatable {

    }

    enum Action: Equatable {
        case dummy
    }

    struct Environment {}

    static var reducer: Reducer<State, Action, Environment> = {
        Reducer.init { state, action, env in
            switch action {
            case .dummy:
                return .none
            }
        }
    }()
}
