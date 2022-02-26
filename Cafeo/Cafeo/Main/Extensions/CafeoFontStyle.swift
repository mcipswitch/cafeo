//
//  CafeoFontStyle.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-07-15.
//

import Foundation
import SwiftUI

/// Represents a font style within the Cafeo iOS design system
struct CafeoFontStyle: Equatable {
    var font: CustomFont
    var size: CGFloat
    /*var weight: Weight*/
    var isNumeric: Bool
    /*var dynamicTextStyle: TextStyle*/

    enum CustomFont {
        case orbitronMedium
        case exo2MediumItalic
        case exo2SemiboldItalic
    }

    /*
    enum Weight {
        case bold
        case semibold
        case medium

        var uiKit: UIFont.Weight {
            switch self {
            case .bold:
                return .bold
            case .semibold:
                return .semibold
            case .medium:
                return .medium
            }
        }

        var swiftUi: Font.Weight {
            switch self {
            case .bold:
                return .bold
            case .semibold:
                return .semibold
            case .medium:
                return .medium
            }
        }
    }
    */

    /*
    enum TextStyle {
        case largeTitle
        case headline
        case body
        case subheadline
        case footnote

        var uiKit: UIFont.TextStyle {
            switch self {
            case .largeTitle:
                return .largeTitle
            case .headline:
                return .headline
            case .body:
                return .body
            case .subheadline:
                return .subheadline
            case .footnote:
                return .footnote
            }
        }

        var swiftUi: Font.TextStyle {
            switch self {
            case .largeTitle:
                return .largeTitle
            case .headline:
                return .headline
            case .body:
                return .body
            case .subheadline:
                return .subheadline
            case .footnote:
                return .footnote
            }
        }
    }
 */
}

extension CafeoFontStyle {
    static var mainLabel: Self {
        return .init(font: .exo2MediumItalic, size: 14, isNumeric: false)
    }

    static var digitalLabel: Self {
        return .init(font: .orbitronMedium, size: 42, isNumeric: true)
    }

    static var ratioLabel: Self {
        return .init(font: .orbitronMedium, size: 50, isNumeric: true)
    }

    /// grams, ounces
    static var unitLabel: Self {
        return .init(font: .exo2SemiboldItalic, size: 16, isNumeric: false)
    }

    /// conversion
    static var miniLabel: Self {
        return .init(font: .exo2MediumItalic, size: 12, isNumeric: false)
    }

    /// +, -
    static var quantityStepperLabel: Self {
        return .init(font: .orbitronMedium, size: 16, isNumeric: false)
    }
}
