//
//  CafeoKerning.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2022-02-26.
//

import UIKit

/// Represents a kerning constant within the Cafeo iOS design system
enum CafeoKerning: CGFloat, RawRepresentable {
    case standard = 1.5
    case large = 4.0
}

extension CGFloat {
    /// Returns the corresponding Cafeo kerning
    static func cafeo(_ kerning: CafeoKerning) -> CGFloat {
        kerning.rawValue
    }
}
