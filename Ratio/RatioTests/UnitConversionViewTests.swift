//
//  UnitConversionViewTests.swift
//  RatioTests
//
//  Created by Priscilla Ip on 2021-03-17.
//

import ComposableArchitecture
import XCTest
@testable import Ratio

class UnitConversionView: XCTestCase {
    let scheduler = DispatchQueue.testScheduler

    func testUnitConversionToggledToOunces() throws {
        let coffeeAmount: Double = 15.625
        let waterAmount: Double = 250

        let store = TestStore(
            initialState: AppState(
                coffeeAmount: coffeeAmount,
                waterAmount: waterAmount,
                unitConversion: .grams
            ),
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler()
            )
        )

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
    }

    func testUnitConversionToggledToGrams() throws {
        let coffeeAmount: Double = 15.625
        let waterAmount: Double = 250

        let store = TestStore(
            initialState: AppState(
                coffeeAmount: coffeeAmount,
                waterAmount: waterAmount,
                unitConversion: .ounces
            ),
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler()
            )
        )

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
}
