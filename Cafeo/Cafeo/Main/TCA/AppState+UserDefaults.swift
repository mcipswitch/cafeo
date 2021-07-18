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
        UserDefaultsState(settings: self.currentSettings, savedPresets: self.savedPresetsState.savedPresets)
    }

    public init(userDefaults: UserDefaultsState? = nil) {
        self.currentSettings = userDefaults?.settings ?? .initial
        self.savedPresetsState.savedPresets = userDefaults?.savedPresets ?? []
    }
}

extension AppState {

    /// Cherry pick what `CafeoSettings` to save to User Defaults
    public struct CafeoSettings: Equatable, Codable {
        var coffeeAmount: Double
        var waterAmount: Double
        var coffeeAmountIsLocked: Bool
        var waterAmountIsLocked: Bool
        var unitConversion: CafeoUnit
        var activeRatioIdx: Int

        public init(
            coffeeAmount: Double,
            waterAmount: Double,
            coffeeAmountIsLocked: Bool,
            waterAmountIsLocked: Bool,
            unitConversion: CafeoUnit,
            activeRatioIdx: Int
        ) {
            self.coffeeAmount = coffeeAmount
            self.waterAmount = waterAmount
            self.coffeeAmountIsLocked = coffeeAmountIsLocked
            self.waterAmountIsLocked = waterAmountIsLocked
            self.unitConversion = unitConversion
            self.activeRatioIdx = activeRatioIdx
        }

        static var initial: Self {
            return .init(coffeeAmount: 15.625, waterAmount: 250, coffeeAmountIsLocked: true, waterAmountIsLocked: false, unitConversion: .grams, activeRatioIdx: 15)
        }
    }
}
