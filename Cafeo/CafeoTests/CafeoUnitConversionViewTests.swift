//
//  CafeoUnitConversionViewTests.swift
//  CafeoTests
//
//  Created by Priscilla Ip on 2021-03-17.
//

import ComposableArchitecture
import XCTest
@testable import Cafeo

class CafeoUnitConversionViewTests: XCTestCase {
    let scheduler = DispatchQueue.testScheduler

    func testUnitConversionToggled() throws {
        let store = TestStore(
            initialState: .mockCoffeeLocked,
            reducer: appReducer,
            environment: AppEnvironment(
                mainQueue: .failing
            )
        )

        var coffeeAmount = AppState.mockWaterLocked.settings.coffeeAmount
        var waterAmount = AppState.mockWaterLocked.settings.waterAmount
        store.send(.unitConversionToggled) {
            coffeeAmount = Measurement(value: coffeeAmount, unit: UnitMass.grams)
                .converted(to: .ounces)
                .value
            waterAmount = Measurement(value: waterAmount, unit: UnitMass.grams)
                .converted(to: .ounces)
                .value
            $0.settings.unitConversion = .ounces
            $0.settings.coffeeAmount = coffeeAmount
            $0.settings.waterAmount = waterAmount
        }
        store.receive(.generateImpact(style: .medium))

        store.send(.unitConversionToggled) {
            $0.settings.unitConversion = .grams
            $0.settings.coffeeAmount = Measurement(value: coffeeAmount, unit: UnitMass.ounces)
                .converted(to: .grams)
                .value
            $0.settings.waterAmount = Measurement(value: waterAmount, unit: UnitMass.ounces)
                .converted(to: .grams)
                .value
        }
        store.receive(.generateImpact(style: .medium))
    }
}
