//
//  RatioTests.swift
//  RatioTests
//
//  Created by Priscilla Ip on 2021-03-16.
//

import ComposableArchitecture
import XCTest
@testable import Ratio

class RatioTests: XCTestCase {
    func testAmountLockToggled() throws {
        let store = TestStore(
            initialState: AppState(
                coffeeAmountIsLocked: true,
                waterAmountIsLocked: false
            ),
            reducer: appReducer,
            environment: AppEnvironment()
        )

        store.assert(
            .send(.amountLockToggled) {
                $0.coffeeAmountIsLocked = false
                $0.waterAmountIsLocked = true
            }
        )
    }

    func testUnitConversionToggled() throws {
        let coffeeAmount: Double = 15.625
        let waterAmount: Double = 250

        let store = TestStore(
            initialState: AppState(
                coffeeAmount: coffeeAmount,
                waterAmount: waterAmount,
                unitConversion: .grams
            ),
            reducer: appReducer,
            environment: AppEnvironment()
        )

        // grams to ounces
        store.assert(
            .send(.unitConversionToggled) {
                $0.unitConversion = .ounces
                $0.coffeeAmount = Measurement(value: coffeeAmount, unit: UnitMass.grams)
                    .converted(to: .ounces)
                    .value
                $0.waterAmount = Measurement(value: waterAmount, unit: UnitMass.grams)
                    .converted(to: .ounces)
                    .value
            },
            .do {
                _ = XCTWaiter.wait(for: [self.expectation(description: "wait")], timeout: 1)
            },
            .receive(.unitConversionToggleYOffsetChanged) {
                $0.toggleYOffset = UnitMass.ounces.toggleYOffset
            }
        )

        // ounces to grams
        store.assert(
            .send(.unitConversionToggled) {
                $0.unitConversion = .grams
                $0.coffeeAmount = Measurement(value: $0.coffeeAmount, unit: UnitMass.ounces)
                    .converted(to: .grams)
                    .value
                $0.waterAmount = Measurement(value: $0.waterAmount, unit: UnitMass.ounces)
                    .converted(to: .grams)
                    .value
            },
            .do {
                _ = XCTWaiter.wait(for: [self.expectation(description: "wait")], timeout: 1)
            },
            .receive(.unitConversionToggleYOffsetChanged) {
                $0.toggleYOffset = UnitMass.grams.toggleYOffset
            }
        )
    }

    func testCoffeeAmountChangedDecrement() throws {
        let store = TestStore(
            initialState: AppState(
                coffeeAmount: 15.625,
                waterAmount: 250,
                ratioDenominators: [16],
                activeRatioIdx: 0
            ),
            reducer: appReducer,
            environment: AppEnvironment()
        )

        // Decrement
        store.assert(
            .send(.coffeeAmountChanged(.decrement)) {
                $0.coffeeAmount = 15.525
                $0.waterAmount = 15.525 / $0.ratio
            }
        )
    }

    func testCoffeeAmountAdjusted() throws {
        let store = TestStore(
            initialState: AppState(
                coffeeAmount: 15.625,
                waterAmount: 250,
                ratioDenominators: [16],
                activeRatioIdx: 0
            ),
            reducer: appReducer,
            environment: AppEnvironment()
        )

        // Increment
        store.assert(
            .send(.coffeeAmountChanged(.increment)) {
                $0.coffeeAmount = 15.725
                $0.waterAmount = 15.725 / $0.ratio
            }
        )
    }

    func testWaterAmountChangedDecrement() throws {
        let store = TestStore(
            initialState: AppState(
                coffeeAmount: 15.625,
                waterAmount: 250,
                ratioDenominators: [16],
                activeRatioIdx: 0
            ),
            reducer: appReducer,
            environment: AppEnvironment()
        )

        // Decrement
        store.assert(
            .send(.waterAmountChanged(.decrement)) {
                $0.coffeeAmount = 249.0 * $0.ratio
                $0.waterAmount = 249.0
            }
        )
    }

    func testWaterAmountChangedIncrement() throws {
        let store = TestStore(
            initialState: AppState(
                coffeeAmount: 15.625,
                waterAmount: 250,
                ratioDenominators: [16],
                activeRatioIdx: 0
            ),
            reducer: appReducer,
            environment: AppEnvironment()
        )

        // Increment
        store.assert(
            .send(.waterAmountChanged(.increment)) {
                $0.coffeeAmount = 251 * $0.ratio
                $0.waterAmount = 251
            }
        )
    }
}
