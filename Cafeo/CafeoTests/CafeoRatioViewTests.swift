//
//  CafeoRatioViewTests.swift
//  CafeoTests
//
//  Created by Priscilla Ip on 2021-03-17.
//

import ComposableArchitecture
import XCTest
@testable import Cafeo

class CafeoRatioViewTests: XCTestCase {

    func testActiveRatioIdxChanged() throws {
        // Setup
        let store = TestStore(
            initialState: .mock,
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: .failing
            )
        )

        // Test
        store.send(.setActiveRatioIdx(index: 15)) {
            // Validate
            $0.settings.activeRatioIdx = 15
            $0.settings.waterAmount = $0.settings.coffeeAmount / $0.ratio
            $0.settings.coffeeAmount = $0.settings.waterAmount * $0.ratio
            XCTAssertEqual($0.activeRatioDenominator, 16)
        }

        store.receive(.generateImpact(style: .medium))

        // Test
        store.send(.setActiveRatioIdx(index: 19)) {
            // Validate
            $0.settings.activeRatioIdx = 19
            $0.settings.waterAmount = $0.settings.coffeeAmount / $0.ratio
            $0.settings.coffeeAmount = $0.settings.waterAmount * $0.ratio
            XCTAssertEqual($0.activeRatioDenominator, 20)
        }

        store.receive(.generateImpact(style: .medium))
    }
}
