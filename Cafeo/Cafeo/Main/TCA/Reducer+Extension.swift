//
//  Reducer+Extension.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-13.
//

import ComposableArchitecture

extension Reducer {
//    func form(
//        action formAction: CasePath<Action, FormAction<State>>
//    ) -> Self {
//        Self { state, action, environment in
//            guard let formAction = formAction.extract(from: action) else {
//                return self.run(&state, action, environment)
//            }
//
//            formAction.setter(&state)
//            return self.run(&state, action, environment)
//        }
//    }

    /// Please see: https://forums.swift.org/t/saving-and-restoring-appstate/39838
    func userDefaults<LocalState>(
        _ key: String = "com.prsclla.cafeo.appState",
        state toLocalState: @escaping (State) -> LocalState,
        environment toUserDefaultsEnvironment: @escaping (Environment) -> UserDefaultsEnvironment = { _ in
            UserDefaultsEnvironment()
        }
    ) -> Reducer where LocalState: Equatable, LocalState: Encodable {
        return .init { state, action, environment in
            let previousState = toLocalState(state)

            let effects = self.run(&state, action, environment)
            let nextState = toLocalState(state)

            guard previousState != nextState else { return effects }

            let userDefaultsEnvironment = toUserDefaultsEnvironment(environment)

            return .merge(
                .fireAndForget {
                    userDefaultsEnvironment.queue.async {
                        guard let data = try? JSONEncoder().encode(nextState) else { return }
                        userDefaultsEnvironment.userDefaults.set(data, forKey: key)
                    }
                },
                effects
            )
        }
    }
}

struct UserDefaultsEnvironment {
    var userDefaults = UserDefaults.init()
    var queue = DispatchQueue.main
}
