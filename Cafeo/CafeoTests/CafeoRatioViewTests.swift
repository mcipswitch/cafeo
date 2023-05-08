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

    func testActiveRatioIdxChangedWithCoffeeLocked() throws {
        let store = TestStore(
            initialState: .mockCoffeeLocked,
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: .failing
            )
        )
        let coffeeAmount = AppState.mockWaterLocked.settings.coffeeAmount
        store.send(.setActiveRatioIdx(index: 15)) {
            $0.settings.activeRatioIdx = 15
            $0.settings.waterAmount = coffeeAmount / $0.ratio
            $0.settings.coffeeAmount = coffeeAmount
            XCTAssertEqual($0.ratio, 1 / 16)
        }
        store.receive(.generateImpact(style: .medium))

        store.send(.setActiveRatioIdx(index: 19)) {
            $0.settings.activeRatioIdx = 19
            $0.settings.waterAmount = coffeeAmount / $0.ratio
            $0.settings.coffeeAmount = coffeeAmount
            XCTAssertEqual($0.ratio, 1 / 20)
        }
        store.receive(.generateImpact(style: .medium))
    }

    func testActiveRatioIdxChangedWithWaterLocked() throws {
        let store = TestStore(
            initialState: .mockWaterLocked,
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: .failing
            )
        )
        let waterAmount = AppState.mockWaterLocked.settings.waterAmount
        store.send(.setActiveRatioIdx(index: 15)) {
            $0.settings.activeRatioIdx = 15
            $0.settings.waterAmount = waterAmount
            $0.settings.coffeeAmount = waterAmount * $0.ratio
            XCTAssertEqual($0.ratio, 1 / 16)
        }
        store.receive(.generateImpact(style: .medium))

        store.send(.setActiveRatioIdx(index: 19)) {
            $0.settings.activeRatioIdx = 19
            $0.settings.waterAmount = waterAmount
            $0.settings.coffeeAmount = waterAmount * $0.ratio
            XCTAssertEqual($0.ratio, 1 / 20)
        }
        store.receive(.generateImpact(style: .medium))
    }
}
