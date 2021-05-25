//
//  WaterAmountViewTests.swift
//  CafeoTests
//
//  Created by Priscilla Ip on 2021-03-17.
//

import ComposableArchitecture
import SnapshotTesting
import XCTest
@testable import Cafeo

class WaterAmountViewTests: XCTestCase {
    let scheduler = DispatchQueue.testScheduler
    
    func testWaterAmountChanged() throws {
        // Setup
        var waterAmount: Double = 250

        let store = TestStore(
            initialState: AppState(
                waterAmount: waterAmount,
                ratioCarouselActiveIdx: 0,
                ratioDenominators: [16]
            ),
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: .failing
            )
        )

        // Test + Validate
        store.send(.waterAmountChanged(.decrement)) {
            waterAmount -= 1

            $0.coffeeAmount = waterAmount * $0.ratio
            $0.waterAmount = waterAmount
        }

        store.send(.waterAmountChanged(.increment)) {
            waterAmount += 1

            $0.coffeeAmount = waterAmount * $0.ratio
            $0.waterAmount = waterAmount
        }

        store.send(.waterAmountChanged(.increment)) {
            waterAmount += 1

            $0.coffeeAmount = waterAmount * $0.ratio
            $0.waterAmount = waterAmount
        }
    }

    func testWaterAmountChangedBelowZeroDoesNothing() {
        // Setup
        let store = TestStore(
            initialState: AppState(
                coffeeAmount: 1/16,
                waterAmount: 1,
                ratioCarouselActiveIdx: 0,
                ratioDenominators: [16]
            ),
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: .failing
            )
        )

        // Test + Validate
        store.send(.coffeeAmountChanged(.decrement)) {
            $0.coffeeAmount = 0
            $0.waterAmount = 0
        }

        store.send(.coffeeAmountChanged(.decrement)) {
            $0.coffeeAmount = 0
            $0.waterAmount = 0
        }
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
        store.send(.adjustAmountButtonLongPressed(.water, .increment))

        self.scheduler.advance(by: .seconds(0.2))

        store.receive(.waterAmountChanged(.increment)) {
            waterAmount += 1

            $0.coffeeAmount = waterAmount * $0.ratio
            $0.waterAmount = waterAmount
        }

        store.receive(.waterAmountChanged(.increment)) {
            waterAmount += 1

            $0.coffeeAmount = waterAmount * $0.ratio
            $0.waterAmount = waterAmount
        }

        // cancel the timer
        store.send(.form(.set(\.isLongPressing, false)))
    }
}
