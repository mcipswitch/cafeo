//
//  CafeoPresetDomain.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-07-18.
//

import ComposableArchitecture
import Foundation

struct CafeoPresetDomain {
    
    struct State: Equatable, Identifiable, Codable {
        var id = UUID()
        var name: String
        var settings: AppState.CafeoSettings
    }

    enum Action: Equatable {
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
