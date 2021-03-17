//
//  WaterAmountViewTests.swift
//  RatioTests
//
//  Created by Priscilla Ip on 2021-03-17.
//

import ComposableArchitecture
import XCTest
@testable import Ratio

class WaterAmountViewTests: XCTestCase {
    let scheduler = DispatchQueue.testScheduler
    
    func testWaterAmountChanged() throws {
        // Setup
        var waterAmount: Double = 250

        let store = TestStore(
            initialState: AppState(
                waterAmount: waterAmount,
                ratioDenominators: [16],
                activeRatioIdx: 0
            ),
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler()
            )
        )

        // Test + Validate
        store.assert(
            .send(.waterAmountChanged(.decrement)) {
                waterAmount -= 1

                $0.coffeeAmount = waterAmount * $0.ratio
                $0.waterAmount = waterAmount
            },
            .send(.waterAmountChanged(.increment)) {
                waterAmount += 1

                $0.coffeeAmount = waterAmount * $0.ratio
                $0.waterAmount = waterAmount
            },
            .send(.waterAmountChanged(.increment)) {
                waterAmount += 1

                $0.coffeeAmount = waterAmount * $0.ratio
                $0.waterAmount = waterAmount
            }
        )
    }

    func testWaterAmountChangedBelowZeroDoesNothing() {
        // Setup
        let store = TestStore(
            initialState: AppState(
                coffeeAmount: 1/16,
                waterAmount: 1,
                ratioDenominators: [16],
                activeRatioIdx: 0
            ),
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler()
            )
        )

        // Test + Validate
        store.assert(
            .send(.coffeeAmountChanged(.decrement)) {
                $0.coffeeAmount = 0
                $0.waterAmount = 0
            },
            .send(.coffeeAmountChanged(.decrement)) {
                $0.coffeeAmount = 0
                $0.waterAmount = 0
            }
        )
    }

    func testWaterAmountButtonLongPressed() throws {
        // Setup
        var waterAmount: Double = 250

        let store = TestStore(
            initialState: AppState(
                waterAmount: waterAmount
            ),
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler()
            )
        )
        store.assert(
            .send(.adjustAmountButtonLongPressed(.water, .increment)),
            .do { self.scheduler.advance(by: .seconds(0.2)) },
            .receive(.waterAmountChanged(.increment)) {
                waterAmount += 1

                $0.coffeeAmount = waterAmount * $0.ratio
                $0.waterAmount = waterAmount
            },
            .receive(.waterAmountChanged(.increment)) {
                waterAmount += 1

                $0.coffeeAmount = waterAmount * $0.ratio
                $0.waterAmount = waterAmount
            },
            // cancel the timer
            .send(.form(.set(\.isLongPressing, false)))
        )
    }
}
