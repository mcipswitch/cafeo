//
//  CafeoFontStyle.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-07-15.
//

import Foundation
import SwiftUI

struct CafeoFontStyle: Equatable {
    var font: CustomFont
    var size: CGFloat
    var isNumeric: Bool

    enum CustomFont {
        case orbitronMedium
        case exo2MediumItalic
        case exo2SemiboldItalic
    }
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
    static var unitLabel: Self {
        return .init(font: .exo2SemiboldItalic, size: 16, isNumeric: false)
    }
    static var miniLabel: Self {
        return .init(font: .exo2MediumItalic, size: 12, isNumeric: false)
    }
    static var quantityStepperLabel: Self {
        return .init(font: .orbitronMedium, size: 16, isNumeric: false)
    }
}

extension View {
    func cafeoText(_ fontStyle: CafeoFontStyle, color: Color) -> some View {
        self.font(.cafeo(fontStyle))
            .foregroundColor(color)
    }
}

extension Font {
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
