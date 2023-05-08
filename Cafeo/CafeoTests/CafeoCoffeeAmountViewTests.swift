//
//  CafeoCoffeeAmountViewTests.swift
//  CafeoTests
//
//  Created by Priscilla Ip on 2021-03-17.
//

import ComposableArchitecture
import XCTest
@testable import Cafeo

class CafeoCoffeeAmountViewTests: XCTestCase {
    let scheduler = DispatchQueue.testScheduler

    func testCoffeeStepperTap() throws {
        let store = TestStore(
            initialState: .mockCoffeeLocked,
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: .failing
            )
        )
        var coffeeAmount = AppState.mockWaterLocked.settings.coffeeAmount
        store.send(.coffeeAction(.quantityStepperAction(.onTap(step: .increment))))
        store.receive(.updateCoffeeAmount(.increment)) {
            coffeeAmount += 0.1
            $0.settings.coffeeAmount = coffeeAmount
            $0.settings.waterAmount = coffeeAmount / $0.ratio
        }
        store.receive(.generateImpact(style: .medium))
        store.send(.coffeeAction(.quantityStepperAction(.onTap(step: .decrement))))
        store.receive(.updateCoffeeAmount(.decrement)) {
            coffeeAmount -= 0.1
            $0.settings.coffeeAmount = coffeeAmount
            $0.settings.waterAmount = coffeeAmount / $0.ratio
        }
        store.receive(.generateImpact(style: .medium))
    }

    func testCoffeeStepperLongPressed() throws {
        let store = TestStore(
            initialState: .mockCoffeeLocked,
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: self.scheduler.eraseToAnyScheduler()
            )
        )
        store.send(.quantityButtonLongPressed(.coffee, .increment))
        self.scheduler.advance(by: 0.2)

        var coffeeAmount = AppState.mockWaterLocked.settings.coffeeAmount
        store.receive(.updateCoffeeAmount(.increment)) {
            coffeeAmount += 0.1
            $0.settings.coffeeAmount = coffeeAmount
            $0.settings.waterAmount = coffeeAmount / $0.ratio
        }
        store.receive(.generateImpact(style: .medium))
        store.receive(.updateCoffeeAmount(.increment)) {
            coffeeAmount += 0.1
            $0.settings.coffeeAmount = coffeeAmount
            $0.settings.waterAmount = coffeeAmount / $0.ratio
        }
        store.receive(.generateImpact(style: .medium))
        store.send(.onRelease)

        store.send(.quantityButtonLongPressed(.coffee, .decrement))
        self.scheduler.advance(by: 0.2)

        store.receive(.updateCoffeeAmount(.decrement)) {
            coffeeAmount -= 0.1
            $0.settings.coffeeAmount = coffeeAmount
            $0.settings.waterAmount = coffeeAmount / $0.ratio
        }
        store.receive(.generateImpact(style: .medium))
        store.receive(.updateCoffeeAmount(.decrement)) {
            coffeeAmount -= 0.1
            $0.settings.coffeeAmount = coffeeAmount
            $0.settings.waterAmount = coffeeAmount / $0.ratio
        }
        store.receive(.generateImpact(style: .medium))
        store.send(.onRelease)
    }

    func testCoffeeAmountChangedWithWaterLocked() throws {
        let store = TestStore(
            initialState: .mockWaterLocked,
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: .failing
            )
        )
        var coffeeAmount = AppState.mockWaterLocked.settings.coffeeAmount
        store.send(.coffeeAction(.quantityStepperAction(.onTap(step: .increment))))
        store.receive(.updateCoffeeAmount(.increment)) {
            coffeeAmount += 0.1
            $0.settings.coffeeAmount = coffeeAmount
            $0.settings.waterAmount = coffeeAmount / $0.ratio
        }
        store.receive(.setLockedIngredient(ingredient: .coffee)) {
            $0.settings.lockedIngredient = .coffee
        }
        store.receive(.generateImpact(style: .medium))
    }

    func testCoffeeAmountDoesNotGoBelowZero() {
        let store = TestStore(
            initialState: AppState(userDefaults: .init(
                settings: .init(
                    coffeeAmount: 0.1,
                    waterAmount: 1.6,
                    lockedIngredient: .coffee,
                    unitConversion: .grams,
                    activeRatioIdx: 0)
            )),
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: .failing
            )
        )
        store.send(.updateCoffeeAmount(.decrement)) {
            $0.settings.coffeeAmount = 0
            $0.settings.waterAmount = 0
        }
        store.receive(.generateImpact(style: .medium))
        store.send(.updateCoffeeAmount(.decrement)) {
            $0.settings.coffeeAmount = 0
            $0.settings.waterAmount = 0
        }
        store.receive(.generateImpact(style: .medium))
    }
}
