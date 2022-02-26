//
//  AppState+Helpers.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-13.
//

import SwiftUI

enum IngredientAction {
    case increment
    case decrement
}

enum CafeoIngredient: String, Codable {
    case coffee
    case water
}

enum CafeoUnit: String, Codable {
    case grams
    case ounces
}

extension CafeoUnit {
    var abbrString: String {
        switch self {
        case .grams: return CommonStrings.abbreviatedGrams
        case .ounces: return CommonStrings.abbreviatedOunces
        }
    }
    var toggleYOffset: CGFloat {
        switch self {
        case .grams: return -30
        case .ounces: return 30
        }
    }
}
