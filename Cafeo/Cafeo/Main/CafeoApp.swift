//
//  CafeoApp.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-02-08.
//

import SwiftUI
import ComposableArchitecture

@main
struct CafeoApp: App {
    let userDefaultsKey = "com.prsclla.cafeo.appState"
    var userDefaults: AppState.UserDefaultsState? {
        UserDefaults.standard.data(forKey: self.userDefaultsKey)
            .flatMap { try?
                JSONDecoder().decode(AppState.UserDefaultsState.self, from: $0)
            }
    }

    var body: some Scene {
        WindowGroup {
            Cafeo(store: Store(
                initialState: AppState(userDefaults: self.userDefaults),
                reducer: appReducer
                    //.debug()
                    .userDefaults(
                        self.userDefaultsKey,
                        state: { state in state.userDefaults }
                    ),
                environment: AppEnvironment(
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                )
            ))
        }
    }
}
