//
//  AppState.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-02-08.
//

import ComposableArchitecture
import SwiftUI

struct AppState: Equatable {
    var settings: AppState.PresetSettings = .initialCoffeeLocked
    var ratioDenominators: [Int] = Array(1...20)
    var coffeeAmountState: CafeoCoffeeAmountDomain.State = .init(amount: 0, isLocked: false)
    var waterAmountState: CafeoWaterAmountDomain.State = .init(amount: 0, isLocked: false)
}

extension AppState {
    var ratio: Double {
        1 / Double(self.ratioDenominators[self.settings.activeRatioIdx])
    }
}

enum AppAction: Equatable {
    case coffeeAction(CafeoCoffeeAmountDomain.Action)
    case generateImpact(style: UIImpactFeedbackGenerator.FeedbackStyle)
    case quantityButtonLongPressed(CafeoIngredient, IngredientAction)
    case onRelease
    case setActiveRatioIdx(index: Int)
    case setLockedIngredient(ingredient: CafeoIngredient)
    case unitConversionToggled
    case updateCoffeeAmount(IngredientAction)
    case updateWaterAmount(IngredientAction)
    case waterAction(CafeoWaterAmountDomain.Action)
    case none
}

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, env in
    struct TimerID: Hashable {}

    func calculateCoffeeAmount() {
        state.settings.coffeeAmount = state.settings.waterAmount * state.ratio
    }
    func calculateWaterAmount() {
        state.settings.waterAmount = state.settings.coffeeAmount / state.ratio
    }
    func convert(_ value: inout Double, fromUnit: UnitMass, toUnit: UnitMass) {
        let measurement = Measurement(value: value, unit: fromUnit)
        value = measurement.converted(to: toUnit).value
    }

    switch action {
    case .none:
        return .none

    case .generateImpact(let style):
        HapticFeedbackManager.shared.generateImpact(style)
        return .none

    case .setActiveRatioIdx(let index):
        state.settings.activeRatioIdx = index
        switch state.settings.lockedIngredient {
        case .coffee:
            calculateWaterAmount()
        case .water:
            calculateCoffeeAmount()
        }
        return Effect(value: .generateImpact(style: .medium))

    case .setLockedIngredient(let ingredient):
        state.settings.lockedIngredient = ingredient
        return Effect(value: .generateImpact(style: .medium))

    case .unitConversionToggled:
        switch state.settings.unitConversion {
        case .grams:
            state.settings.unitConversion = .ounces
            convert(&state.settings.coffeeAmount, fromUnit: .grams, toUnit: .ounces)
            convert(&state.settings.waterAmount, fromUnit: .grams, toUnit: .ounces)

        case .ounces:
            state.settings.unitConversion = .grams
            convert(&state.settings.coffeeAmount, fromUnit: .ounces, toUnit: .grams)
            convert(&state.settings.waterAmount, fromUnit: .ounces, toUnit: .grams)
        }

        return Effect(value: .generateImpact(style: .medium))

    case let .updateWaterAmount(action):
        switch action {
        case .increment:
            state.settings.waterAmount += 1

        case .decrement:
            let newValue = state.settings.waterAmount.rounded() - 1
            if newValue > 0 {
                state.settings.waterAmount -= 1
            } else if newValue == 0 {
                state.settings.waterAmount = 0
            }
        }

        calculateCoffeeAmount()

        switch state.settings.lockedIngredient {
        case .coffee:
            return Effect(value: .setLockedIngredient(ingredient: .water))
        case .water:
            return Effect(value: .generateImpact(style: .medium))
        }

    case let .updateCoffeeAmount(action):
        switch action {
        case .increment:
            state.settings.coffeeAmount += 0.1

        case .decrement:
            let newValue = state.settings.coffeeAmount.round(to: 1) - 0.1
            if newValue > 0 {
                state.settings.coffeeAmount -= 0.1
            } else if newValue == 0 {
                state.settings.coffeeAmount = 0
            }
        }

        calculateWaterAmount()

        switch state.settings.lockedIngredient {
        case .coffee:
            return Effect(value: .generateImpact(style: .medium))
        case .water:
            return Effect(value: .setLockedIngredient(ingredient: .coffee))
        }

    case let .quantityButtonLongPressed(ingredient, action):
        return Effect.timer(id: TimerID(), every: 0.1, on: env.mainQueue)
            .map { _ in
                switch ingredient {
                case .coffee:
                    return .updateCoffeeAmount(action)
                case .water:
                    return .updateWaterAmount(action)
                }
            }

    case .onRelease:
        return .cancel(id: TimerID())

    case .coffeeAction(let action):
        switch action {
        case .lockAmount:
            return Effect(value: .setLockedIngredient(ingredient: .coffee))

        case .quantityStepperAction(let action):
            switch action {
            case .onPress(let step):
                return Effect(value: .quantityButtonLongPressed(.coffee, step))

            case .onRelease:
                return Effect(value: .onRelease)

            case .onTap(let step):
                return Effect(value: .updateCoffeeAmount(step))
            }
        }

    case .waterAction(let action):
        switch action {
        case .lockAmount:
            return Effect(value: .setLockedIngredient(ingredient: .water))

        case .quantityStepperAction(let action):
            switch action {
            case .onPress(step: let step):
                return Effect(value: .quantityButtonLongPressed(.water, step))

            case .onRelease:
                return Effect(value: .onRelease)

            case .onTap(step: let step):
                return Effect(value: .updateWaterAmount(step))
            }
        }
    }
}
