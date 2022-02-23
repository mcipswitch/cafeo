//
//  CafeoIngredientAmountDomain.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2022-02-23.
//

import ComposableArchitecture
import Foundation

struct CafeoCoffeeAmountDomain {

    struct State: Equatable {


//        var savedPresets: IdentifiedArrayOf<CafeoPresetDomain.State>
//
//        static var empty: Self {
//            return .init(savedPresets: [])
//        }
    }

    enum Action: Equatable {
//        case savePreset(CafeoPresetDomain.State)
//        case deletePreset(IndexSet)
//        case movePreset(IndexSet, Int)
//
//        case presetAction(id: CafeoPresetDomain.State.ID, action: CafeoPresetDomain.Action)
        case dummy
    }

    struct Environment {}

    static let reducer: Reducer<State, Action, Environment> = {
        return .init { state, action, env in
            switch action {
            case .dummy:
                return .none
            }
        }
    }()
}
