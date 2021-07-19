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
        var settings: CafeoSettings
        var savedPresets: IdentifiedArrayOf<CafeoPresetDomain.State>

        public init(settings: CafeoSettings, savedPresets: IdentifiedArrayOf<CafeoPresetDomain.State>) {
            self.settings = settings
            self.savedPresets = savedPresets
        }
    }

    var userDefaults: UserDefaultsState {
        UserDefaultsState(settings: self.settings, savedPresets: self.savedPresetsState.savedPresets)
    }

    public init(userDefaults: UserDefaultsState? = nil) {
        self.settings = userDefaults?.settings ?? .initial
        self.savedPresetsState.savedPresets = userDefaults?.savedPresets ?? []
    }
}

extension AppState {

    /// Cherry pick what `CafeoSettings` to save to User Defaults
    public struct CafeoSettings: Equatable, Codable {
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

        static var initial: Self {
            return .init(coffeeAmount: 15.625, waterAmount: 250, lockedIngredient: .coffee, unitConversion: .grams, activeRatioIdx: 15)
        }
    }
}
