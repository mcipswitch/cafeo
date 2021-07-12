//
//  CafeoUnitConversionViewTests.swift
//  CafeoTests
//
//  Created by Priscilla Ip on 2021-03-17.
//

import ComposableArchitecture
import SnapshotTesting
import XCTest
@testable import Cafeo

class CafeoUnitConversionViewTests: XCTestCase {
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
                mainQueue: .failing
            )
        )

        store.send(.unitConversionToggled) {
            $0.unitConversion = .ounces
            $0.coffeeAmount = Measurement(value: coffeeAmount, unit: UnitMass.grams)
                .converted(to: .ounces)
                .value
            $0.waterAmount = Measurement(value: waterAmount, unit: UnitMass.grams)
                .converted(to: .ounces)
                .value
        }
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
                mainQueue: .failing
            )
        )

        store.send(.unitConversionToggled) {
            $0.unitConversion = .grams
            $0.coffeeAmount = Measurement(value: $0.coffeeAmount, unit: UnitMass.ounces)
                .converted(to: .grams)
                .value
            $0.waterAmount = Measurement(value: $0.waterAmount, unit: UnitMass.ounces)
                .converted(to: .grams)
                .value
        }
    }
}
