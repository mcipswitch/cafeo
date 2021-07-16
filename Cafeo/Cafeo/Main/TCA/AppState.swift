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
    var unitConversion: CafeoUnit = .grams

    var ratioCarouselActiveIdx: Int = 15
    var ratioDenominators = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]

    var currentAction: IngredientAction?
}

extension AppState {
    var unitConversionToggleYOffset: CGFloat { self.unitConversion.toggleYOffset }
    var activeRatioDenominator: Int { self.ratioDenominators[self.ratioCarouselActiveIdx] }
    var ratio: Double { 1 / Double(self.activeRatioDenominator) }
}

enum AppAction: Equatable {
    case quantityButtonLongPressed(CafeoIngredient, IngredientAction)
    case coffeeAmountChanged(IngredientAction)
    case waterAmountChanged(IngredientAction)
    case amountLockToggled
    case unitConversionToggled

    case quantityLabelDragged(CafeoIngredient, IngredientAction)

    case onRelease

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

        return !state.waterAmountIsLocked
            ? Effect(value: AppAction.amountLockToggled)
            : .none

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

        return !state.coffeeAmountIsLocked
            ? Effect(value: AppAction.amountLockToggled)
            : .none

    case .amountLockToggled:
        HapticFeedbackManager.shared.generateImpact(.medium)
        state.waterAmountIsLocked.toggle()
        state.coffeeAmountIsLocked.toggle()
        return .none

    case .quantityButtonLongPressed(let ingredient, let action):
        return Effect.timer(id: TimerID(), every: 0.1, on: env.mainQueue)
            .map { _ in
                ingredient == .coffee
                    ? .coffeeAmountChanged(action)
                    : .waterAmountChanged(action)
            }

    case .quantityLabelDragged(let ingredient, let newAction):

        let effect = Effect.timer(id: TimerID(), every: 0.05, on: env.mainQueue)
            .map { _ in
                ingredient == .coffee
                    ? AppAction.coffeeAmountChanged(newAction)
                    : AppAction.waterAmountChanged(newAction)
            }

        /// If there is no current action, update it
        guard let currentAction = state.currentAction else {
            state.currentAction = newAction
            return effect
        }

        /// If the new action is distinct, cancel the timer and update the effect
        guard currentAction == newAction else {
            state.currentAction = newAction
            return Effect.concatenate(.cancel(id: TimerID()), effect)
        }

        /// Otherwise, do nothing
        return .none

    case .onRelease:
        state.currentAction = nil
        return .cancel(id: TimerID())

    // MARK: Form Action

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
