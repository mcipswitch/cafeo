//
//  CafeoCoffeeAmountViewTests.swift
//  CafeoTests
//
//  Created by Priscilla Ip on 2021-03-17.
//

import ComposableArchitecture
import SnapshotTesting
import XCTest
@testable import Cafeo

class CafeoCoffeeAmountViewTests: XCTestCase {
    let scheduler = DispatchQueue.testScheduler

    func testCoffeeAmountChanged() throws {
        // Setup
        var coffeeAmount: Double = 15.725

        let store = TestStore(
            initialState: AppState(
                coffeeAmount: coffeeAmount,
                waterAmount: 250,
                coffeeAmountIsLocked: false,
                waterAmountIsLocked: true,
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
            coffeeAmount -= 0.1

            $0.coffeeAmount = coffeeAmount
            $0.waterAmount = coffeeAmount / $0.ratio
        }

        store.receive(.amountLockToggled) {
            $0.waterAmountIsLocked = false
            $0.coffeeAmountIsLocked = true
        }

        store.send(.coffeeAmountChanged(.increment)) {
            coffeeAmount += 0.1

            $0.coffeeAmount = coffeeAmount
            $0.waterAmount = coffeeAmount / $0.ratio
        }

        store.send(.coffeeAmountChanged(.increment)) {
            coffeeAmount += 0.1

            $0.coffeeAmount = coffeeAmount
            $0.waterAmount = coffeeAmount / $0.ratio
        }
    }

    func testCoffeeAmountChangedBelowZeroDoesNothing() {
        // Setup
        let store = TestStore(
            initialState: AppState(
                coffeeAmount: 0.1,
                waterAmount: 1.6,
                ratioCarouselActiveIdx: 0, ratioDenominators: [16]
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

    func testCoffeeAmountButtonLongPressed() throws {
        // Setup
        var coffeeAmount: Double = 15.725

        let store = TestStore(
            initialState: AppState(
                coffeeAmount: coffeeAmount,
                coffeeAmountIsLocked: false,
                waterAmountIsLocked: true
            ),
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler()
            )
        )

        // Test + Validate
        store.send(.quantityButtonLongPressed(.coffee, .increment))

        self.scheduler.advance(by: .seconds(0.2))

        store.receive(.coffeeAmountChanged(.increment)) {
            coffeeAmount += 0.1
            $0.coffeeAmount = coffeeAmount
            $0.waterAmount = coffeeAmount / $0.ratio
        }

        store.receive(.amountLockToggled) {
            $0.waterAmountIsLocked = false
            $0.coffeeAmountIsLocked = true
        }

        store.receive(.coffeeAmountChanged(.increment)) {
            coffeeAmount += 0.1
            $0.coffeeAmount = coffeeAmount
            $0.waterAmount = coffeeAmount / $0.ratio
        }

        // cancel the timer
        store.send(.form(.set(\.isLongPressing, false)))
    }

    // Does not have to be re-tested in WaterAmountViewTests
    func testCoffeeAmountLockToggled() throws {
        // Setup
        let coffeeAmount: Double = 250 / 16
        var waterAmount: Double = 250
        
        let store = TestStore(
            initialState: AppState(
                coffeeAmount: coffeeAmount,
                waterAmount: waterAmount,
                coffeeAmountIsLocked: true,
                waterAmountIsLocked: false
            ),
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: .failing
            )
        )

        // Test + validate
        store.send(.form(.set(\.ratioCarouselActiveIdx, 14))) {
            $0.ratioCarouselActiveIdx = 14
            waterAmount = coffeeAmount / $0.ratio
            $0.waterAmount = waterAmount
        }

        store.send(.amountLockToggled) {
            $0.coffeeAmountIsLocked = false
            $0.waterAmountIsLocked = true
        }

        store.send(.form(.set(\.ratioCarouselActiveIdx, 16))) {
            $0.ratioCarouselActiveIdx = 16
            $0.coffeeAmount = waterAmount * $0.ratio
        }
    }
}
