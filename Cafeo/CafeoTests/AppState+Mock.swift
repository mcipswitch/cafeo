//
//  AppState+Mock.swift
//  CafeoTests
//
//  Created by Priscilla Ip on 2022-02-25.
//

import Foundation

extension AppState {

    static var mock: Self {
        .init(
            settings: .initial,
            ratioDenominators: Array(1...20),
            currentAction: nil,
            showSavedPresetsView: false,
            showSavePresetAlert: false,
            coffeeAmountState: .mock,
            waterAmountState: .mock,
            savedPresetsState: .empty,
            selectedPreset: nil
        )
    }
}
