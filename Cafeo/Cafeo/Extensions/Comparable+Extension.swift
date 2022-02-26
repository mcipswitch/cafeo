//
//  Comparable+Extension.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-13.
//

import SwiftUI

extension Comparable {
    /// Force value to fall within a specific range.
    /// - Parameters:
    ///   - low: The low end of range.
    ///   - high: The high end of range.
    /// - Returns: Clamped data.
    func clamp(low: Self, high: Self) -> Self {
        if (self > high) {
            return high
        } else if (self < low) {
            return low
        }
        return self
    }
}
