//
//  AppState+Mock.swift
//  CafeoTests
//
//  Created by Priscilla Ip on 2022-02-25.
//

import Foundation

extension AppState {
    
    static var mockCoffeeLocked: Self {
        .init(
            settings: .initialCoffeeLocked,
            ratioDenominators: Array(1...20),
            coffeeAmountState: .init(
                amount: 15.625,
                isLocked: false
            ),
            waterAmountState: .init(
                amount: 250,
                isLocked: true
            )
        )
    }

    static var mockWaterLocked: Self {
        .init(
            settings: .initialWaterLocked,
            ratioDenominators: Array(1...20),
            coffeeAmountState: .init(
                amount: 15.625,
                isLocked: false
            ),
            waterAmountState: .init(
                amount: 250,
                isLocked: true
            )
        )
    }
}
