//
//  AppState.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-02-08.
//

import SwiftUI
import ComposableArchitecture

extension AppState {

    static var mock: Self {
        .init(
            settings: .initial,
            ratioDenominators: Array(1...20),
            currentAction: nil,
            showSavedPresetsView: false,
            showSavePresetAlert: false,
            coffeeAmountState: .mock,
            waterAmountState: .mock,
            savedPresetsState: .empty,
            selectedPreset: nil
        )
    }
}

struct AppState: Equatable {

    var settings: AppState.PresetSettings = .initial

    // Array of denominators for the ratio.
    var ratioDenominators: [Int] = Array(1...20)

    var currentAction: IngredientAction?

    var showSavedPresetsView = false
    var showSavePresetAlert = false

    var coffeeAmountState: CafeoCoffeeAmountDomain.State = .init(amount: 0, isLocked: false)
    var waterAmountState: CafeoWaterAmountDomain.State = .init(amount: 0, isLocked: false)

    // MARK: CafeoSavedPresetsDomain
    var savedPresetsState: CafeoSavedPresetsDomain.State = .empty

    // MARK: CafeoPresetDomain
    var selectedPreset: CafeoPresetDomain.State?
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
    case showSavedPresetsView(Bool)
    case setActiveRatioIdx(index: Int)
    case setLockedIngredient(ingredient: CafeoIngredient)

    case updateCoffeeAmount(IngredientAction)
    case updateWaterAmount(IngredientAction)
    case unitConversionToggled

    // MARK: Ingredient Quantity
    case quantityButtonLongPressed(CafeoIngredient, IngredientAction)
    case quantityLabelDragged(CafeoIngredient, IngredientAction)
    case onRelease

    case updateSettings(CafeoPresetDomain.State)

    case coffeeAction(CafeoCoffeeAmountDomain.Action)
    case waterAction(CafeoWaterAmountDomain.Action)

    // MARK: CafeoSavedPresetsDomain
    case savedPresetsAction(CafeoSavedPresetsDomain.Action)

    case none
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

        case .none:
            return .none

        case .generateImpact(let style):
            HapticFeedbackManager.shared.generateImpact(style)
            return .none

        case .toggleSavePresetAlert:
            state.showSavePresetAlert.toggle()
            return .none

        case .showSavedPresetsView(let value):
            state.showSavedPresetsView = value
            return .none

        case .setActiveRatioIdx(let index):
            state.settings.activeRatioIdx = index
            state.settings.lockedIngredient == .coffee ? updateWaterAmount() : updateCoffeeAmount()
            return Effect(value: .generateImpact(style: .medium))

        case .setLockedIngredient(let ingredient):
            state.settings.lockedIngredient = ingredient
            return Effect(value: .generateImpact(style: .medium))

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

            // MARK: - CafeoSavedPresetsDomain

        case let .savedPresetsAction(.savePreset(preset)):
            // Add delay so user can see the settings update.
            return Effect(value: .updateSettings(preset))
                .delay(for: 0.350, scheduler: env.mainQueue)
                .eraseToEffect()

        case .savedPresetsAction(.newPresetSelected(let preset)):
            state.showSavedPresetsView = false

            // Add delay so user can see the settings update.
            return Effect(value: .updateSettings(preset))
                .delay(for: 0.350, scheduler: env.mainQueue)
                .eraseToEffect()

        case .savedPresetsAction:
            return .none /* ignore other actions */

            // MARK: - Coffee Domain

        case .coffeeAction(let action):
            switch action {
            case .lockAmount:
                return Effect(value: .setLockedIngredient(ingredient: .coffee))

            case .quantityStepperAction(let action):
                switch action {
                case .onPress(step: let step):
                    return Effect(value: .quantityButtonLongPressed(.coffee, step))

                case .onRelease:
                    return Effect(value: .onRelease)

                case .onTap(step: let step):
                    return Effect(value: .updateCoffeeAmount(step))
                }

            case .amountDragged(let step):
                return Effect(value: .quantityLabelDragged(.coffee, step))

            case .onDragRelease:
                return Effect(value: .onRelease)
            }

            // MARK: - Water Domain

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

            case .amountDragged(let step):
                return Effect(value: .quantityLabelDragged(.water, step))

            case .onDragRelease:
                return Effect(value: .onRelease)
            }
        }
    }
)
