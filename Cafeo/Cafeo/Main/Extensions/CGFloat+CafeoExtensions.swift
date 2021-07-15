//
//  CGFloat+CafeoExtensions.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-07-15.
//

import SwiftUI

/// Represents a spacing constant within the Cafeo iOS design system
enum CafeoSpacing: CGFloat, RawRepresentable {
    case scale05 = 2
    case scale1 = 4
    case scale2 = 8
    case scale3 = 12
    case scale4 = 16
    case scale45 = 20
    case scale5 = 24
    case scale55 = 30
    case scale6 = 32
    case scale7 = 48
}

/// Represents a kerning constant within the Cafeo iOS design system
enum CafeoKerning: CGFloat, RawRepresentable {
    case standard = 1.5
    case large = 4.0
}

extension CGFloat {
    /// Returns the corresponding Cafeo spacing
    static func cafeo(_ spacing: CafeoSpacing) -> CGFloat {
        spacing.rawValue
    }

    /// Returns the corresponding Cafeo kerning
    static func cafeo(_ kerning: CafeoKerning) -> CGFloat {
        kerning.rawValue
    }
}
