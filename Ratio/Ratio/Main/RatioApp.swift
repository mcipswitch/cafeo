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
    var body: some Scene {
        WindowGroup {
            Coffio(store: Store(initialState: AppState(),
                                reducer: appReducer,
                                environment: AppEnvironment(
                                    mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                                )
            ))
        }
    }
}
