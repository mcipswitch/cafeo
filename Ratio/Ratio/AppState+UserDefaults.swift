//
//  AppState+UserDefaults.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-03-18.
//

import Foundation

extension AppState {

    // Cherry pick what to save to userDefaults
    public struct UserDefaultsState: Equatable, Codable {
        var coffeeAmount: Double
        var waterAmount: Double
        var coffeeAmountIsLocked: Bool
        var waterAmountIsLocked: Bool
        var unitConversion: CoffioUnit
        var activeRatioIdx: Int

        public init(
            coffeeAmount: Double,
            waterAmount: Double,
            coffeeAmountIsLocked: Bool,
            waterAmountIsLocked: Bool,
            unitConversion: CoffioUnit,
            activeRatioIdx: Int
        ) {
            self.coffeeAmount = coffeeAmount
            self.waterAmount = waterAmount
            self.coffeeAmountIsLocked = coffeeAmountIsLocked
            self.waterAmountIsLocked = waterAmountIsLocked
            self.unitConversion = unitConversion
            self.activeRatioIdx = activeRatioIdx
        }
    }

    var userDefaults: UserDefaultsState {
        UserDefaultsState(
            coffeeAmount: self.coffeeAmount,
            waterAmount: self.waterAmount,
            coffeeAmountIsLocked: self.coffeeAmountIsLocked,
            waterAmountIsLocked: self.waterAmountIsLocked,
            unitConversion: self.unitConversion,
            activeRatioIdx: self.ratioCarouselActiveIdx)
    }

    public init(userDefaults: UserDefaultsState? = nil) {
        self.coffeeAmount = userDefaults?.coffeeAmount ?? 15.625
        self.waterAmount = userDefaults?.waterAmount ?? 250
        self.coffeeAmountIsLocked = userDefaults?.coffeeAmountIsLocked ?? true
        self.waterAmountIsLocked = userDefaults?.waterAmountIsLocked ?? false
        self.unitConversion = userDefaults?.unitConversion ?? .grams
        self.ratioCarouselActiveIdx = userDefaults?.activeRatioIdx ?? 15
    }
}
