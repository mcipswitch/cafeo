//
//  CommonStrings.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2023-05-07.
//

import Foundation

enum CommonStrings {
    static var coffee: String {
        NSLocalizedString(
            "CommonStrings.coffee",
            value: "coffee",
            comment: "label for coffee"
        )
    }
    static var water: String {
        NSLocalizedString(
            "CommonStrings.water",
            value: "water",
            comment: "label for water"
        )
    }
    static var conversion: String {
        NSLocalizedString(
            "CommonStrings.conversion",
            value: "conversion",
            comment: "label for conversion view"
        )
    }
    static var abbreviatedGrams: String {
        NSLocalizedString(
            "CommonStrings.abbreviatedGrams",
            value: "gr",
            comment: "abbreviated label for grams"
        )
    }
    static var abbreviatedOunces: String {
        NSLocalizedString(
            "CommonStrings.abbreviatedOunces",
            value: "oz",
            comment: "abbreviated label for ounces"
        )
    }
}
