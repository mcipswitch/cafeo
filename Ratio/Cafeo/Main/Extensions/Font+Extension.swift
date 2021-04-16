//
//  Font+Extension.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-10.
//

import SwiftUI

extension Font {
    static func orbitronMediumFont(size: CGFloat) -> Font {
        return Font.custom("Orbitron-Medium", fixedSize: size)
    }

    static func exo2MediumItalicFont(size: CGFloat) -> Font {
        return Font.custom("Exo2-MediumItalic", fixedSize: size)
    }

    static func exo2SemiBoldItalicFont(size: CGFloat) -> Font {
        return Font.custom("Exo2-SemiBold", fixedSize: size)
    }
}

// MARK: - CafeoTextStyle

enum CafeoTextStyle {
    case mainLabel
    case digitalLabel
    case ratioLabel
    case unitLabel
    case miniLabel
    case adjustButtonLabel

    var font: Font {
        switch self {
        case .mainLabel:
            return .exo2MediumItalicFont(size: 14)
        case .digitalLabel:
            return .orbitronMediumFont(size: 42)
        case .ratioLabel:
            return .orbitronMediumFont(size: 50)
        case .unitLabel:
            return .exo2SemiBoldItalicFont(size: 16)
        case .miniLabel:
            return .exo2MediumItalicFont(size: 12)
        case .adjustButtonLabel:
            return .orbitronMediumFont(size: 16)
        }
    }

    var color: Color {
        switch self {
        case .digitalLabel, .ratioLabel:
            return .cafeoBeige
        default:
            return .cafeoGray
        }
    }

    var kerning: CGFloat {
        switch self {
        case .digitalLabel, .ratioLabel:
            return 4.0
        default:
            return 1.5
        }
    }

    var textCase: Text.Case {
        switch self {
        case .unitLabel:
            return .lowercase
        default:
            return .uppercase
        }
    }
}

// MARK: - CafeoTextModifier

struct CafeoTextModifier: ViewModifier {
    var textStyle: CafeoTextStyle
    var state: CafeoTextState

    init(_ textStyle: CafeoTextStyle, state: CafeoTextState = .normal) {
        self.textStyle = textStyle
        self.state = state
    }

    func body(content: Content) -> some View {
        content
            .font(self.textStyle.font)

            // TODO: - revisit this
            .foregroundColor(
                self.state == .selected ? .cafeoOrange : self.textStyle.color
            )
    }
}

// MARK: - Enum Helper

enum CafeoTextState {
    case normal
    case selected
}
