//
//  RatioViewTests.swift
//  RatioTests
//
//  Created by Priscilla Ip on 2021-03-17.
//

import ComposableArchitecture
import XCTest
@testable import Ratio

class RatioViewTests: XCTestCase {
    let scheduler = DispatchQueue.testScheduler

    func testActiveRatioIdxChanged() throws {
        // Setup
        let waterAmount: Double = 250

        let store = TestStore(
            initialState: AppState(
                coffeeAmount: 250 / 16,
                waterAmount: waterAmount,
                coffeeAmountIsLocked: false,
                waterAmountIsLocked: true,
                ratioDenominators: [14, 15, 16, 17],
                activeRatioIdx: 0
            ),
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler()
            )
        )

        // Test + Validate
        store.assert(
            .send(.form(.set(\.activeRatioIdx, 1))) {
                $0.activeRatioIdx = 1
                $0.coffeeAmount = waterAmount * $0.ratio
                XCTAssertEqual($0.activeRatioDenominator, 15)
            },
            .send(.form(.set(\.activeRatioIdx, 2))) {
                $0.activeRatioIdx = 2
                $0.coffeeAmount = waterAmount * $0.ratio
                XCTAssertEqual($0.activeRatioDenominator, 16)
            },
            .send(.form(.set(\.activeRatioIdx, 3))) {
                $0.activeRatioIdx = 3
                $0.coffeeAmount = waterAmount * $0.ratio
                XCTAssertEqual($0.activeRatioDenominator, 17)
            }
        )
    }
}
