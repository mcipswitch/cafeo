//
//  CafeoSpacing.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-07-15.
//

import SwiftUI

/// Represents a spacing constant within the Cafeo iOS design system
enum CafeoSpacing: CGFloat, RawRepresentable {
    case spacing2 = 2
    case spacing4 = 4
    case spacing6 = 6
    case spacing8 = 8
    case spacing10 = 10
    case spacing12 = 12
    case spacing16 = 16
    case spacing20 = 20
    case spacing24 = 24
    case spacing30 = 30
    case spacing32 = 32
    case spacing48 = 48
}

extension CGFloat {
    /// Returns the corresponding Cafeo spacing
    static func cafeo(_ spacing: CafeoSpacing) -> CGFloat {
        spacing.rawValue
    }
}
