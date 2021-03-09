//
//  AppState.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-02-08.
//

import SwiftUI
import ComposableArchitecture

// MARK: - Domain

struct AppState: Equatable {
    var ratioDenominator: Double = 16
    var coffeeAmount: Double = 15.6
    var waterAmount: Double = 250
    var lockCoffeeAmount = true
    var lockWaterAmount = false

    var unitOfMeasurementIdx: Int = 0

    var unit: UnitMass = .grams

    var ratio: Double {
        1 / self.ratioDenominator
    }
}

enum AppAction: Equatable {
    case coffeeDecrementButtonTapped
    case coffeeIncrementButtonTapped
    case waterDecrementButtonTapped
    case waterIncrementButtonTapped

    case unitChanged
    case form(FormAction<AppState>)
}

struct AppEnvironment { }

// MARK: - FormAction

struct FormAction<Root>: Equatable {
    let keyPath: PartialKeyPath<Root>
    let value: AnyHashable
    let setter: (inout Root) -> Void

    init<Value>(
        _ keyPath: WritableKeyPath<Root, Value>,
        _ value: Value
    ) where Value: Hashable {
        self.keyPath = keyPath
        self.value = value
        self.setter = { $0[keyPath: keyPath] = value }
    }

    static func set<Value>(
        _ keyPath: WritableKeyPath<Root, Value>,
        _ value: Value
    ) -> Self where Value: Hashable {
        .init(keyPath, value)
    }

    static func == (lhs: FormAction<Root>, rhs: FormAction<Root>) -> Bool {
        lhs.keyPath == rhs.keyPath && lhs.value == rhs.value
    }
}

// MARK: - AppReducer

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case .unitChanged:
        switch state.unit {
        case .grams:
            state.unit = .ounces

            let coffeeGrams = Measurement(value: state.coffeeAmount, unit: UnitMass.grams)
            let coffeeOunces = coffeeGrams.converted(to: .ounces)
            let waterGrams = Measurement(value: state.waterAmount, unit: UnitMass.grams)
            let waterOunces = waterGrams.converted(to: .ounces)

            state.coffeeAmount = coffeeOunces.value
            state.waterAmount = waterOunces.value

            return .none

        case .ounces:
            state.unit = .grams

            let coffeeOunces = Measurement(value: state.coffeeAmount, unit: UnitMass.ounces)
            let coffeeGrams = coffeeOunces.converted(to: .grams)
            let waterOunces = Measurement(value: state.waterAmount, unit: UnitMass.ounces)
            let waterGrams = waterOunces.converted(to: .grams)

            state.coffeeAmount = coffeeGrams.value
            state.waterAmount = waterGrams.value

            return .none

        default:
            return .none
        }

    case .coffeeDecrementButtonTapped:
        if state.coffeeAmount > 0 {
            state.coffeeAmount -= 0.1
        }
        return Effect(value: .form(.set(\.waterAmount, state.coffeeAmount / state.ratio)))

    case .coffeeIncrementButtonTapped:
        state.coffeeAmount += 0.1
        return Effect(value: .form(.set(\.waterAmount, state.coffeeAmount / state.ratio)))

    case .waterDecrementButtonTapped:
        state.waterAmount -= 1
        return Effect(value: .form(.set(\.coffeeAmount, state.waterAmount * state.ratio)))

    case .waterIncrementButtonTapped:
        state.waterAmount += 1
        return Effect(value: .form(.set(\.coffeeAmount, state.waterAmount * state.ratio)))

    case .form(\.ratioDenominator):
        if state.lockWaterAmount {
            return Effect(value: .form(.set(\.coffeeAmount, state.waterAmount * state.ratio)))
        } else if state.lockCoffeeAmount {
            return Effect(value: .form(.set(\.waterAmount, state.coffeeAmount / state.ratio)))
        } else {
            return .none
        }

    case .form(\.lockWaterAmount):
        state.lockCoffeeAmount.toggle()
        return .none

    case .form(\.lockCoffeeAmount):
        state.lockWaterAmount.toggle()
        return .none

    case .form:
        return .none
    }
}
.form(action: /AppAction.form)
.debug()

// MARK: - Reducer + Extension

func ~= <Root, Value> (
    keyPath: WritableKeyPath<Root, Value>,
    formAction: FormAction<Root>
) -> Bool {
    formAction.keyPath == keyPath
}

extension Reducer {
    func form(
        action formAction: CasePath<Action, FormAction<State>>
    ) -> Self {
        Self { state, action, environment in
            guard let formAction = formAction.extract(from: action) else {
                return self.run(&state, action, environment)
            }

            formAction.setter(&state)
            return self.run(&state, action, environment)
        }
    }
}








//        func feedback() {
//            let generator = UIImpactFeedbackGenerator(style: .light)
//            generator.impactOccurred()
//        }


extension UnitMass {
    var abbrString: String {
        switch self {
        case .grams:
            return "gr"
        case .ounces:
            return "oz"
        default:
            return ""
        }
    }
}
