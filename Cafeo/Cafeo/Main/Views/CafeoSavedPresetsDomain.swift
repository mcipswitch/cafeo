//
//  CafeoSavedPresetsDomain.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-07-18.
//

import ComposableArchitecture
import Foundation

struct CafeoSavedPresetsDomain {

    struct State: Equatable {
        var savedPresets: IdentifiedArrayOf<CafeoPresetDomain.State>
    }

    enum Action: Equatable {
        case presetAction(id: CafeoPresetDomain.State.ID, action: CafeoPresetDomain.Action)

        case savePreset(CafeoPresetDomain.State)
        case deletePreset(IndexSet)
    }

    struct Environment {}

    static let reducer: Reducer<State, Action, Environment> = {
        return .combine(
            CafeoPresetDomain.reducer.forEach(
                state: \.savedPresets,
                action: /CafeoSavedPresetsDomain.Action.presetAction(id:action:),
                environment: { _ in .init() }
            ),

            Reducer.init { state, action, env in
                switch action {

                case let .savePreset(preset):
                    state.savedPresets.append(preset)
                    return .none

                case let .deletePreset(indexSet):
                    state.savedPresets.remove(atOffsets: indexSet)
                    return .none

                case .presetAction:
                    return .none
                }
            }
        )
    }()
}
