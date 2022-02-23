//
//  AppState.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-02-08.
//

import SwiftUI
import ComposableArchitecture

struct AppState: Equatable {

    var settings: AppState.PresetSettings = .initial

    // Array of denominators for the ratio.
    var ratioDenominators: [Int] = Array(1...20)

    var currentAction: IngredientAction?

    var savedPresetsState: CafeoSavedPresetsDomain.State = .empty
    var selectedPreset: CafeoPresetDomain.State?

    var showSavedPresetsView = false
    var showSavePresetAlert = false
}

extension AppState {
    
    var unitConversionToggleYOffset: CGFloat {
        self.settings.unitConversion.toggleYOffset
    }
    var activeRatioDenominator: Int {
        self.ratioDenominators[self.settings.activeRatioIdx]
    }
    var ratio: Double {
        1 / Double(self.activeRatioDenominator)
    }
}

enum AppAction: Equatable {

    // MARK: Haptics
    case generateImpact(style: UIImpactFeedbackGenerator.FeedbackStyle)

    case toggleSavePresetAlert
    case toggleShowSavedPresetsView
    case setActiveRatioIdx(index: Int)
    case setLockedIngredient(ingredient: CafeoIngredient)

    case updateCoffeeAmount(IngredientAction)
    case updateWaterAmount(IngredientAction)
    case unitConversionToggled

    case quantityButtonLongPressed(CafeoIngredient, IngredientAction)
    case quantityLabelDragged(CafeoIngredient, IngredientAction)
    case onRelease

    case newPresetSelected(CafeoPresetDomain.State)
    case updateSettings(CafeoPresetDomain.State)

    // MARK: Saved Presets Domain
    case savedPresetsAction(CafeoSavedPresetsDomain.Action)
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

        func updateCoffeeAmount() {
            state.settings.coffeeAmount = state.settings.waterAmount * state.ratio
        }

        func updateWaterAmount() {
            state.settings.waterAmount = state.settings.coffeeAmount / state.ratio
        }

        func convert(_ value: inout Double, fromUnit: UnitMass, toUnit: UnitMass) {
            let measurement = Measurement(value: value, unit: fromUnit)
            value = measurement.converted(to: toUnit).value
        }

        switch action {

        case .generateImpact(let style):
            HapticFeedbackManager.shared.generateImpact(style)
            return .none

        case .toggleSavePresetAlert:
            state.showSavePresetAlert.toggle()
            return .none

        case .toggleShowSavedPresetsView:
            state.showSavedPresetsView.toggle()
            return .none

        case .setActiveRatioIdx(let index):
            state.settings.activeRatioIdx = index
            state.settings.lockedIngredient == .coffee ? updateWaterAmount() : updateCoffeeAmount()
            return Effect(value: .generateImpact(style: .medium))

        case .setLockedIngredient(let ingredient):
            state.settings.lockedIngredient = ingredient
            return Effect(value: .generateImpact(style: .medium))

        case .newPresetSelected(let preset):
            // Add delay so user can see the settings update.
            return Effect(value: .updateSettings(preset))
                .delay(for: 0.350, scheduler: env.mainQueue)
                .eraseToEffect()

        case .updateSettings(let preset):
            state.selectedPreset = preset
            state.settings = preset.settings
            return .none

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

            HapticFeedbackManager.shared.generateImpact(.medium)
            updateCoffeeAmount()

            return state.settings.lockedIngredient == .coffee
            ? Effect(value: .setLockedIngredient(ingredient: .water))
            : .none

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

            HapticFeedbackManager.shared.generateImpact(.medium)
            updateWaterAmount()

            return state.settings.lockedIngredient == .water
            ? Effect(value: .setLockedIngredient(ingredient: .coffee))
            : .none

        case .quantityButtonLongPressed(let ingredient, let action):
            return Effect.timer(id: TimerID(), every: 0.1, on: env.mainQueue)
                .map { _ in
                    ingredient == .coffee ? .updateCoffeeAmount(action) : .updateWaterAmount(action)
                }

        case .quantityLabelDragged(let ingredient, let newAction):

            let effect = Effect.timer(id: TimerID(), every: 0.05, on: env.mainQueue)
                .map { _ in
                    ingredient == .coffee ? AppAction.updateCoffeeAmount(newAction) : AppAction.updateWaterAmount(newAction)
                }

            // If there is no current action, update it.
            guard let currentAction = state.currentAction else {
                state.currentAction = newAction
                return effect
            }

            // If the new action is distinct, cancel the timer and update the effect.
            guard currentAction == newAction else {
                state.currentAction = newAction
                return Effect.concatenate(.cancel(id: TimerID()), effect)
            }

            // Otherwise, do nothing
            return .none

        case .onRelease:
            state.currentAction = nil
            return .cancel(id: TimerID())

        // MARK: SavedPresetsDomain

        case let .savedPresetsAction(.savePreset(preset)):
            // Add delay so user can see the settings update.
            return Effect(value: .updateSettings(preset))
                .delay(for: 0.350, scheduler: env.mainQueue)
                .eraseToEffect()

        case .savedPresetsAction:
            return .none /* ignore other actions */
        }
    }
)
