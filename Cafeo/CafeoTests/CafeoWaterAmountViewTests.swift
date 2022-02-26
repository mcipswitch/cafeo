//
//  CafeoWaterAmountViewTests.swift
//  CafeoTests
//
//  Created by Priscilla Ip on 2021-03-17.
//

import ComposableArchitecture
import XCTest
@testable import Cafeo

class CafeoWaterAmountViewTests: XCTestCase {
    let scheduler = DispatchQueue.testScheduler

    func testWaterStepperTap() throws {
        let store = TestStore(
            initialState: .mockWaterLocked,
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: .failing
            )
        )
        var waterAmount = AppState.mockWaterLocked.settings.waterAmount
        store.send(.waterAction(.quantityStepperAction(.onTap(step: .increment))))
        store.receive(.updateWaterAmount(.increment)) {
            waterAmount += 1.0
            $0.settings.waterAmount = waterAmount
            $0.settings.coffeeAmount = waterAmount * $0.ratio
        }
        store.receive(.generateImpact(style: .medium))
        store.send(.waterAction(.quantityStepperAction(.onTap(step: .decrement))))
        store.receive(.updateWaterAmount(.decrement)) {
            waterAmount -= 1.0
            $0.settings.waterAmount = waterAmount
            $0.settings.coffeeAmount = waterAmount * $0.ratio
        }
        store.receive(.generateImpact(style: .medium))
    }

    func testWaterStepperLongPressed() throws {
        let store = TestStore(
            initialState: .mockWaterLocked,
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: self.scheduler.eraseToAnyScheduler()
            )
        )
        store.send(.quantityButtonLongPressed(.water, .increment))
        self.scheduler.advance(by: 0.2)

        var waterAmount = AppState.mockWaterLocked.settings.waterAmount
        store.receive(.updateWaterAmount(.increment)) {
            waterAmount += 1.0
            $0.settings.waterAmount = waterAmount
            $0.settings.coffeeAmount = waterAmount * $0.ratio
        }
        store.receive(.generateImpact(style: .medium))
        store.receive(.updateWaterAmount(.increment)) {
            waterAmount += 1.0
            $0.settings.waterAmount = waterAmount
            $0.settings.coffeeAmount = waterAmount * $0.ratio
        }
        store.receive(.generateImpact(style: .medium))
        store.send(.onRelease)

        store.send(.quantityButtonLongPressed(.water, .decrement))
        self.scheduler.advance(by: 0.2)

        store.receive(.updateWaterAmount(.decrement)) {
            waterAmount -= 1.0
            $0.settings.waterAmount = waterAmount
            $0.settings.coffeeAmount = waterAmount * $0.ratio
        }
        store.receive(.generateImpact(style: .medium))
        store.receive(.updateWaterAmount(.decrement)) {
            waterAmount -= 1.0
            $0.settings.waterAmount = waterAmount
            $0.settings.coffeeAmount = waterAmount * $0.ratio
        }
        store.receive(.generateImpact(style: .medium))
        store.send(.onRelease)
    }

    func testWaterAmountChangedWithCoffeeLocked() throws {
        let store = TestStore(
            initialState: .mockCoffeeLocked,
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: .failing
            )
        )
        var waterAmount = AppState.mockWaterLocked.settings.waterAmount
        store.send(.waterAction(.quantityStepperAction(.onTap(step: .increment))))
        store.receive(.updateWaterAmount(.increment)) {
            waterAmount += 1.0
            $0.settings.waterAmount = waterAmount
            $0.settings.coffeeAmount = waterAmount * $0.ratio
        }
        store.receive(.setLockedIngredient(ingredient: .water)) {
            $0.settings.lockedIngredient = .water
        }
        store.receive(.generateImpact(style: .medium))
    }

    func testWaterAmountDoesNotGoBelowZero() {
        let store = TestStore(
            initialState: AppState(userDefaults: .init(
                settings: .init(
                    coffeeAmount: 0.0625,
                    waterAmount: 1.0,
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
