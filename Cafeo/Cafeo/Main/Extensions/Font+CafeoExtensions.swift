//
//  Font+CafeoExtensions.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-07-15.
//

import Foundation
import SwiftUI

extension Font {

    /// Creates the font corresponding to the Cafeo style.
    static func cafeo(_ style: CafeoFontStyle) -> Font {
        switch style.font {
        case .orbitronMedium:
            var font = Font.custom("Orbitron-Medium", fixedSize: style.size)
            if style.isNumeric {
                font = font.monospacedDigit()
            }

            return font

        case .exo2MediumItalic:
            var font = Font.custom("Exo2-MediumItalic", fixedSize: style.size)
            if style.isNumeric {
                font = font.monospacedDigit()
            }

            return font

        case .exo2SemiboldItalic:
            var font = Font.custom("Exo2-SemiBold", fixedSize: style.size)
            if style.isNumeric {
                font = font.monospacedDigit()
            }

            return font
        }
    }
}
