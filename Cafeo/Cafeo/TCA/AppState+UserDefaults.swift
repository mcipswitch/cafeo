//
//  AppState+UserDefaults.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-18.
//

import ComposableArchitecture
import Foundation

extension AppState {
    public struct UserDefaultsState: Equatable, Codable {
        var settings: PresetSettings

        public init(settings: PresetSettings) {
            self.settings = settings
        }
    }

    var userDefaults: UserDefaultsState {
        UserDefaultsState(settings: self.settings)
    }

    public init(userDefaults: UserDefaultsState? = nil) {
        self.settings = userDefaults?.settings ?? .initialCoffeeLocked
    }
}

extension AppState {

    public struct PresetSettings: Equatable, Codable {
        var coffeeAmount: Double
        var waterAmount: Double
        var lockedIngredient: CafeoIngredient
        var unitConversion: CafeoUnit
        var activeRatioIdx: Int

        public init(
            coffeeAmount: Double,
            waterAmount: Double,
            lockedIngredient: CafeoIngredient,
            unitConversion: CafeoUnit,
            activeRatioIdx: Int
        ) {
            self.coffeeAmount = coffeeAmount
            self.waterAmount = waterAmount
            self.lockedIngredient = lockedIngredient
            self.unitConversion = unitConversion
            self.activeRatioIdx = activeRatioIdx
        }

        static var initialCoffeeLocked: Self {
            return .init(
                coffeeAmount: 15.625,
                waterAmount: 250,
                lockedIngredient: .coffee,
                unitConversion: .grams,
                activeRatioIdx: 15
            )
        }

        static var initialWaterLocked: Self {
            return .init(
                coffeeAmount: 15.625,
                waterAmount: 250,
                lockedIngredient: .water,
                unitConversion: .ounces,
                activeRatioIdx: 15
            )
        }
    }
}
