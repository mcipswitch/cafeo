//
//  AppState.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-02-08.
//

import SwiftUI
import ComposableArchitecture

struct AppState: Equatable {
    var currentSettings: AppState.CafeoSettings = .initial
    var ratioDenominators = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]

    var currentAction: IngredientAction?

    var selectedPreset: CafeoPresetDomain.State?
    var savedPresetsState: CafeoSavedPresetsDomain.State = .init(savedPresets: [])
}

extension AppState {
    var unitConversionToggleYOffset: CGFloat { self.currentSettings.unitConversion.toggleYOffset }
    var activeRatioDenominator: Int { self.ratioDenominators[self.currentSettings.activeRatioIdx] }
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

    case newPresetSelected(CafeoPresetDomain.State)
    case currentSettingsUpdated(CafeoPresetDomain.State)

    // MARK: SavedPresetsDomain
    case savedPresetsAction(CafeoSavedPresetsDomain.Action)

    // This can be ignored
    case form(FormAction<AppState>)
}

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

// MARK: - AppReducer

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(

    CafeoSavedPresetsDomain.reducer.pullback(
        state: \AppState.savedPresetsState,
        action: /AppAction.savedPresetsAction,
        environment: { _ in .init() }
    ),

    Reducer { state, action, env in

        struct TimerID: Hashable {}
        struct CancelDelayID: Hashable {}

        func updateCoffeeAmount() {
            state.currentSettings.coffeeAmount = state.currentSettings.waterAmount * state.ratio
        }

        func updateWaterAmount() {
            state.currentSettings.waterAmount = state.currentSettings.coffeeAmount / state.ratio
        }

        func convert(_ value: inout Double, fromUnit: UnitMass, toUnit: UnitMass) {
            let measurement = Measurement(value: value, unit: fromUnit)
            value = measurement.converted(to: toUnit).value
        }

        switch action {

        case let .newPresetSelected(preset):
            state.selectedPreset = preset
            return Effect(value: AppAction.currentSettingsUpdated(preset))
                .delay(for: 0.350, scheduler: env.mainQueue)
                .eraseToEffect()

        case let .currentSettingsUpdated(preset):
            state.currentSettings = preset.settings
            return .none

        case .unitConversionToggled:
            switch state.currentSettings.unitConversion {
            case .grams:
                state.currentSettings.unitConversion = .ounces
                convert(&state.currentSettings.coffeeAmount, fromUnit: .grams, toUnit: .ounces)
                convert(&state.currentSettings.waterAmount, fromUnit: .grams, toUnit: .ounces)

            case .ounces:
                state.currentSettings.unitConversion = .grams
                convert(&state.currentSettings.coffeeAmount, fromUnit: .ounces, toUnit: .grams)
                convert(&state.currentSettings.waterAmount, fromUnit: .ounces, toUnit: .grams)
            }

            HapticFeedbackManager.shared.generateImpact(.medium)
            return .none

        case let .waterAmountChanged(action):
            switch action {
            case .increment:
                state.currentSettings.waterAmount += 1
            case .decrement:
                let newValue = state.currentSettings.waterAmount.rounded() - 1
                if newValue > 0 {
                    state.currentSettings.waterAmount -= 1
                } else if newValue == 0 {
                    state.currentSettings.waterAmount = 0
                }
            }

            HapticFeedbackManager.shared.generateImpact(.medium)
            updateCoffeeAmount()

            return !state.currentSettings.waterAmountIsLocked
                ? Effect(value: AppAction.amountLockToggled)
                : .none

        case let .coffeeAmountChanged(action):
            switch action {
            case .increment:
                state.currentSettings.coffeeAmount += 0.1
            case .decrement:
                let newValue = state.currentSettings.coffeeAmount.round(to: 1) - 0.1
                if newValue > 0 {
                    state.currentSettings.coffeeAmount -= 0.1
                } else if newValue == 0 {
                    state.currentSettings.coffeeAmount = 0
                }
            }

            HapticFeedbackManager.shared.generateImpact(.medium)
            updateWaterAmount()

            return !state.currentSettings.coffeeAmountIsLocked
                ? Effect(value: AppAction.amountLockToggled)
                : .none

        case .amountLockToggled:
            HapticFeedbackManager.shared.generateImpact(.medium)
            state.currentSettings.waterAmountIsLocked.toggle()
            state.currentSettings.coffeeAmountIsLocked.toggle()
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


        // MARK: SavedPresetsDomain

        case let .savedPresetsAction(action):
            switch action {
            case let .savePreset(preset):
                state.selectedPreset = preset
                return .none

            case .deletePreset(_):
                return .none

            case .presetAction(id: _, action: _):
                return .none
            }

        // MARK: Form Action

        case .form(\.currentSettings.activeRatioIdx):
            state.currentSettings.waterAmountIsLocked
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
)
