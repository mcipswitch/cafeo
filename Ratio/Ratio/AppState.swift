//
//  AppState.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-02-08.
//

import SwiftUI
import ComposableArchitecture

struct AppState: Equatable {
    var coffeeAmount: Double = 15.625
    var waterAmount: Double = 250
    var coffeeAmountIsLocked = true
    var waterAmountIsLocked = false
    var isLongPressing = false
    var unitConversion: CoffioUnit = .grams

    var ratioCarouselActiveIdx: Int = 15
    var ratioDenominators = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
}

extension AppState {
    var unitConversionToggleYOffset: CGFloat { self.unitConversion.toggleYOffset }
    var activeRatioDenominator: Int { self.ratioDenominators[self.ratioCarouselActiveIdx] }
    var ratio: Double { 1 / Double(self.activeRatioDenominator) }
}

enum AppAction: Equatable {
    case adjustAmountButtonLongPressed(CoffioIngredient, AmountAction)
    case coffeeAmountChanged(AmountAction)
    case waterAmountChanged(AmountAction)
    case amountLockToggled
    case unitConversionToggled

    // This can be ignored
    case form(FormAction<AppState>)
}

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

// MARK: - AppReducer

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, env in

    struct TimerID: Hashable {}
    struct CancelDelayID: Hashable {}

    func updateCoffeeAmount() {
        state.coffeeAmount = state.waterAmount * state.ratio
    }

    func updateWaterAmount() {
        state.waterAmount = state.coffeeAmount / state.ratio
    }

    func convert(_ value: inout Double, fromUnit: UnitMass, toUnit: UnitMass) {
        let measurement = Measurement(value: value, unit: fromUnit)
        value = measurement.converted(to: toUnit).value
    }

    // Action
    switch action {
    case .unitConversionToggled:
        switch state.unitConversion {
        case .grams:
            state.unitConversion = .ounces
            convert(&state.coffeeAmount, fromUnit: .grams, toUnit: .ounces)
            convert(&state.waterAmount, fromUnit: .grams, toUnit: .ounces)

        case .ounces:
            state.unitConversion = .grams
            convert(&state.coffeeAmount, fromUnit: .ounces, toUnit: .grams)
            convert(&state.waterAmount, fromUnit: .ounces, toUnit: .grams)
        }

        HapticFeedbackManager.shared.generateImpact(.medium)
        return .none

    case let .waterAmountChanged(action):
        switch action {
        case .increment:
            state.waterAmount += 1
        case .decrement:
            let newValue = state.waterAmount.rounded() - 1
            if newValue > 0 {
                state.waterAmount -= 1
            } else if newValue == 0 {
                state.waterAmount = 0
            }
        }

        HapticFeedbackManager.shared.generateImpact(.medium)
        updateCoffeeAmount()
        return .none

    case let .coffeeAmountChanged(action):
        switch action {
        case .increment:
            state.coffeeAmount += 0.1
        case .decrement:
            let newValue = state.coffeeAmount.round(to: 1) - 0.1
            if newValue > 0 {
                state.coffeeAmount -= 0.1
            } else if newValue == 0 {
                state.coffeeAmount = 0
            }
        }

        HapticFeedbackManager.shared.generateImpact(.medium)
        updateWaterAmount()
        return .none

    case .amountLockToggled:
        HapticFeedbackManager.shared.generateImpact(.medium)
        state.waterAmountIsLocked.toggle()
        state.coffeeAmountIsLocked.toggle()
        return .none

    case .adjustAmountButtonLongPressed(let ingredient, let action):
        return Effect.timer(id: TimerID(), every: 0.1, on: env.mainQueue)
            .map { _ in
                ingredient == .coffee
                    ? .coffeeAmountChanged(action)
                    : .waterAmountChanged(action)
            }

    case .form(\.isLongPressing):
        return state.isLongPressing ? .none : .cancel(id: TimerID())

    case .form(\.ratioCarouselActiveIdx):
        state.waterAmountIsLocked
            ? updateCoffeeAmount()
            : updateWaterAmount()

        HapticFeedbackManager.shared.generateImpact(.medium)
        return .none

    // This can be ignored
    case .form:
        return .none
    }
}
.form(action: /AppAction.form)
