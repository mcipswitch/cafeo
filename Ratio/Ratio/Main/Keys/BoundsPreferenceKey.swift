//
//  BoundsPreferenceKey.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-03-13.
//

import SwiftUI

struct BoundsPreferenceKey: PreferenceKey {
    static var defaultValue: Anchor<CGRect>? = nil
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = nextValue()
    }
}
