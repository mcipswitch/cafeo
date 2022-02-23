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
        var savedPresets: IdentifiedArrayOf<CafeoPresetDomain.State>
        var selectedPreset: CafeoPresetDomain.State?

        public init(
            settings: PresetSettings,
            savedPresets: IdentifiedArrayOf<CafeoPresetDomain.State>,
            selectedPreset: CafeoPresetDomain.State?
        ) {
            self.settings = settings
            self.savedPresets = savedPresets
            self.selectedPreset = selectedPreset
        }
    }

    var userDefaults: UserDefaultsState {
        UserDefaultsState(
            settings: self.settings,
            savedPresets: self.savedPresetsState.savedPresets,
            selectedPreset: self.selectedPreset
        )
    }

    public init(userDefaults: UserDefaultsState? = nil) {
        self.settings = userDefaults?.settings ?? .initial
        self.savedPresetsState.savedPresets = userDefaults?.savedPresets ?? []
        self.selectedPreset = userDefaults?.selectedPreset
    }
}

extension AppState {

    /// Cherry pick what `PresetSettings` to save to User Defaults
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

        static var initial: Self {
            return .init(
                coffeeAmount: 15.625,
                waterAmount: 250,
                lockedIngredient: .coffee,
                unitConversion: .grams,
                activeRatioIdx: 15
            )
        }
    }
}
