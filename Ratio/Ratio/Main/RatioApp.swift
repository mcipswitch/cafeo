//
//  RatioApp.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-02-08.
//

import SwiftUI
import ComposableArchitecture

@main
struct RatioApp: App {
    let userDefaultsKey = "com.prsclla.coffio.appState"
    var userDefaults: AppState.UserDefaultsState? {
        UserDefaults.standard.data(forKey: userDefaultsKey)
            .flatMap { try?
                JSONDecoder().decode(AppState.UserDefaultsState.self, from: $0)
            }
    }

    var body: some Scene {
        WindowGroup {
            Coffio(store: Store(
                initialState: AppState(userDefaults: userDefaults),
                reducer: appReducer
                    .debug()
                    .userDefaults(
                        userDefaultsKey,
                        state: { state in state.userDefaults }
                    ),
                environment: AppEnvironment(
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                )
            ))
        }
    }
}
