//
//  CoffeeAmountViewTests.swift
//  RatioTests
//
//  Created by Priscilla Ip on 2021-03-17.
//

import ComposableArchitecture
import XCTest
@testable import Ratio

class CoffeeAmountViewTests: XCTestCase {
    let scheduler = DispatchQueue.testScheduler

    func testCoffeeAmountChanged() throws {
        // Setup
        var coffeeAmount: Double = 15.725

        let store = TestStore(
            initialState: AppState(
                coffeeAmount: coffeeAmount,
                waterAmount: 250,
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
                coffeeAmount -= 0.1

                $0.coffeeAmount = coffeeAmount
                $0.waterAmount = coffeeAmount / $0.ratio
            },
            .send(.coffeeAmountChanged(.increment)) {
                coffeeAmount += 0.1

                $0.coffeeAmount = coffeeAmount
                $0.waterAmount = coffeeAmount / $0.ratio
            },
            .send(.coffeeAmountChanged(.increment)) {
                coffeeAmount += 0.1

                $0.coffeeAmount = coffeeAmount
                $0.waterAmount = coffeeAmount / $0.ratio
            }
        )
    }

    func testCoffeeAmountChangedBelowZeroDoesNothing() {
        // Setup
        let store = TestStore(
            initialState: AppState(
                coffeeAmount: 0.1,
                waterAmount: 1.6,
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

    func testCoffeeAmountButtonLongPressed() throws {
        // Setup
        var coffeeAmount: Double = 15.725

        let store = TestStore(
            initialState: AppState(
                coffeeAmount: coffeeAmount
            ),
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler()
            )
        )

        // Test + Validate
        store.assert(
            .send(.adjustAmountButtonLongPressed(.coffee, .increment)),
            .do { self.scheduler.advance(by: .seconds(0.2)) },
            .receive(.coffeeAmountChanged(.increment)) {
                coffeeAmount += 0.1
                $0.coffeeAmount = coffeeAmount
                $0.waterAmount = coffeeAmount / $0.ratio
            },
            .receive(.coffeeAmountChanged(.increment)) {
                coffeeAmount += 0.1
                $0.coffeeAmount = coffeeAmount
                $0.waterAmount = coffeeAmount / $0.ratio
            },
            // cancel the timer
            .send(.form(.set(\.isLongPressing, false)))
        )
    }

    // Does not have to be re-tested in WaterAmountViewTests
    func testCoffeeAmountLockToggled() throws {
        // Setup
        let coffeeAmount: Double = 250 / 16
        var waterAmount: Double = 250

        let scheduler = DispatchQueue.testScheduler
        let store = TestStore(
            initialState: AppState(
                coffeeAmount: coffeeAmount,
                waterAmount: waterAmount,
                coffeeAmountIsLocked: true,
                waterAmountIsLocked: false
            ),
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler()
            )
        )

        // Test + validate
        store.assert(
            .send(.form(.set(\.ratioCarouselActiveIdx, 14))) {
                $0.ratioCarouselActiveIdx = 14
                waterAmount = coffeeAmount / $0.ratio
                $0.waterAmount = waterAmount

            },
            .send(.amountLockToggled) {
                $0.coffeeAmountIsLocked = false
                $0.waterAmountIsLocked = true
            },
            .send(.form(.set(\.ratioCarouselActiveIdx, 16))) {
                $0.ratioCarouselActiveIdx = 16
                $0.coffeeAmount = waterAmount * $0.ratio
            }
        )
    }
}
