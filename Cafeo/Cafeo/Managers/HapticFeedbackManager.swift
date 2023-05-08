//
//  HapticFeedbackManager.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-31.
//

import SwiftUI

final class HapticFeedbackManager {
    private init() {}
    static let shared = HapticFeedbackManager()

    func generateImpact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let impactGenerator = UIImpactFeedbackGenerator(style: style)
        impactGenerator.impactOccurred()
    }
}
