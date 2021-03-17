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

    var unitConversion: UnitMass = .grams
    var toggleYOffset: CGFloat = UnitMass.grams.toggleYOffset

    // Ratio
    var ratioCarouselDragYOffset: CGFloat = .zero
    var ratioCarouselYOffset: CGFloat = .zero

    var ratioDenominators = [
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
    ]

    var activeRatioIdx: Int = 15 // "16"

    // helper vars
    var activeRatioDenominator: Int {
        self.ratioDenominators[self.activeRatioIdx]
    }

    var ratio: Double {
        1 / Double(self.activeRatioDenominator)
    }
}

enum AppAction: Equatable {
    enum CoffioIngredient {
        case coffee
        case water
    }

    case adjustAmountButtonLongPressed(CoffioIngredient, AdjustAmountAction)
    case coffeeAmountChanged(AdjustAmountAction)
    case waterAmountChanged(AdjustAmountAction)

    case unitConversionToggled
    case unitConversionToggleYOffsetChanged

    case amountLockToggled

    // This can be ignored
    case form(FormAction<AppState>)
}

struct AppEnvironment {
    //var mainQueue: AnySchedulerOf<DispatchQueue>
}

// MARK: - AppReducer

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, env in

    struct TimerID: Hashable {}

    func feedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    func updateCoffeeAmount() {
        state.coffeeAmount = state.waterAmount * state.ratio
    }

    func updateWaterAmount() {
        state.waterAmount = state.coffeeAmount / state.ratio
    }

    func convert(_ value: inout Double, from unitA: UnitMass, to unitB: UnitMass) {
        let measurement = Measurement(value: value, unit: unitA)
        value = measurement.converted(to: unitB).value
    }

    // Action
    switch action {
    case .unitConversionToggled:
        switch state.unitConversion {
        case .grams:
            state.unitConversion = .ounces
            convert(&state.coffeeAmount, from: .grams, to: .ounces)
            convert(&state.waterAmount, from: .grams, to: .ounces)

        case .ounces:
            state.unitConversion = .grams
            convert(&state.coffeeAmount, from: .ounces, to: .grams)
            convert(&state.waterAmount, from: .ounces, to: .grams)

        default:
            break
        }

        feedback(.light)
        return Effect(value: AppAction.unitConversionToggleYOffsetChanged)
            .delay(for: 0, scheduler: DispatchQueue.main.animation(                  Animation.timingCurve(0.60, 0.80, 0, 0.96)))
            .eraseToEffect()

    case .unitConversionToggleYOffsetChanged:
        if state.unitConversion == .grams {
            state.toggleYOffset = UnitMass.grams.toggleYOffset
        } else if state.unitConversion == .ounces {
            state.toggleYOffset = UnitMass.ounces.toggleYOffset
        }

        feedback(.light)
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

        feedback(.light)
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

        feedback(.light)
        updateWaterAmount()
        return .none

    case .amountLockToggled:
        feedback(.light)
        state.waterAmountIsLocked.toggle()
        state.coffeeAmountIsLocked.toggle()
        return .none

    case .adjustAmountButtonLongPressed(let ingredient, let action):
        return Effect.timer(id: TimerID(), every: 0.1, on: DispatchQueue.main)
            .map { _ in
                ingredient == .coffee
                    ? .coffeeAmountChanged(action)
                    : .waterAmountChanged(action)
            }

    case .form(\.isLongPressing):
        return state.isLongPressing ? .none : .cancel(id: TimerID())

    case .form(\.activeRatioIdx):
        state.waterAmountIsLocked
            ? updateCoffeeAmount()
            : updateWaterAmount()

        feedback(.light)
        return .none

    // This can be ignored
    case .form:
        return .none
    }
}
.form(action: /AppAction.form)
.debug()
