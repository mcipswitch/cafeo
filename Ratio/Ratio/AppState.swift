//
//  AppState.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-02-08.
//

import SwiftUI
import ComposableArchitecture

struct AppState: Equatable {

    var coffeeAmount: Double = 15.6
    var waterAmount: Double = 250

    var coffeeAmountIsLocked = true
    var waterAmountIsLocked = false

    var isLongPressing = false

    var conversionUnit: UnitMass = .grams
    var toggleYOffset: CGFloat = UnitMass.grams.toggleYOffset

    // Ratio
    var ratioCarouselDragYOffset: CGFloat = .zero
    var ratioCarouselYOffset: CGFloat = .zero

    var ratioDenominators = [
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
    ]

    var activeRatioIdx: Int = 15 // "16"

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

    case unitConversionChanged
    case unitConversionToggleYOffsetChanged

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

    switch action {
    case .unitConversionToggleYOffsetChanged:
        if state.conversionUnit == .grams {
            state.toggleYOffset = UnitMass.ounces.toggleYOffset
        } else if state.conversionUnit == .ounces {
            state.toggleYOffset = UnitMass.grams.toggleYOffset
        }

        feedback(.light)

        return
            Effect(value: AppAction.unitConversionChanged)
            .delay(for: 0, scheduler: DispatchQueue.main.animation(.none))
            .eraseToEffect()

    case .unitConversionChanged:
        switch state.conversionUnit {
        case .grams:
            state.conversionUnit = .ounces

            let coffeeGrams = Measurement(value: state.coffeeAmount, unit: UnitMass.grams)
            let coffeeOunces = coffeeGrams.converted(to: .ounces)
            let waterGrams = Measurement(value: state.waterAmount, unit: UnitMass.grams)
            let waterOunces = waterGrams.converted(to: .ounces)

            state.coffeeAmount = coffeeOunces.value
            state.waterAmount = waterOunces.value

            return .none

        case .ounces:
            state.conversionUnit = .grams

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

    case let .waterAmountChanged(action):
        switch action {
        case .increment:
            feedback(.light)
            state.waterAmount += 1
        case .decrement:
            let newValue = state.waterAmount - 1
            if newValue > 0 {
                feedback(.light)
                state.waterAmount -= 1
            }
        }

        return Effect(value: .form(.set(\.coffeeAmount, state.waterAmount * state.ratio)))

    case let .coffeeAmountChanged(action):
        switch action {
        case .increment:
            feedback(.light)
            state.coffeeAmount += 0.1
        case .decrement:
            let newValue = state.coffeeAmount - 0.1
            if newValue > 0 {
                feedback(.light)
                state.coffeeAmount -= 0.1
            }
        }

        return Effect(value: .form(.set(\.waterAmount, state.coffeeAmount / state.ratio)))

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
        if state.waterAmountIsLocked {
            feedback(.light)
            return Effect(value: .form(.set(\.coffeeAmount, state.waterAmount * state.ratio)))
        } else if state.coffeeAmountIsLocked {
            feedback(.light)
            return Effect(value: .form(.set(\.waterAmount, state.coffeeAmount / state.ratio)))
        } else {
            return .none
        }

    case .form(\.waterAmountIsLocked):
        feedback(.light)
        state.coffeeAmountIsLocked.toggle()
        return .none

    case .form(\.coffeeAmountIsLocked):
        feedback(.light)
        state.waterAmountIsLocked.toggle()
        return .none

    // This can be ignored
    case .form:
        return .none
    }
}
.form(action: /AppAction.form)
.debug()
