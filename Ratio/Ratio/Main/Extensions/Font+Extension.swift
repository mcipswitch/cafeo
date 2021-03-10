//
//  Font+Extension.swift
//  Ratio
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

// MARK: - CoffioTextStyle

enum CoffioTextStyle {
    case mainLabel
    case digitalLabel
    case ratioLabel
    case unitLabel
    case miniLabel

    var font: Font {
        switch self {
        case .mainLabel:
            return .exo2MediumItalicFont(size: 16)
        case .digitalLabel:
            return .orbitronMediumFont(size: 48)
        case .ratioLabel:
            return .orbitronMediumFont(size: 50)
        case .unitLabel:
            return .exo2SemiBoldItalicFont(size: 16)
        case .miniLabel:
            return .exo2MediumItalicFont(size: 12)
        }
    }

    var color: Color {
        switch self {
        case .mainLabel:
            return .coffioGray
        case .digitalLabel:
            return .coffioBeige
        case .ratioLabel:
            return .coffioBeige
        case .unitLabel:
            return .coffioGray
        case .miniLabel:
            return .coffioGray
        }
    }
}

struct CoffioText: ViewModifier {
    var textStyle: CoffioTextStyle

    init(_ textStyle: CoffioTextStyle) {
        self.textStyle = textStyle
    }

    func body(content: Content) -> some View {
        content
            .font(textStyle.font)
            .foregroundColor(textStyle.color)
    }
}
