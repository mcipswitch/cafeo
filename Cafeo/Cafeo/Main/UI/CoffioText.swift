//
//  CoffioText.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-03-13.
//

import SwiftUI

struct CafeoText: View {
    var text: String
    var textStyle: CafeoTextStyle
    var state: CafeoTextState

    init(text: String, state: CafeoTextState = .normal, _ textStyle: CafeoTextStyle) {
        self.text = text
        self.textStyle = textStyle
        self.state = state
    }

    var body: some View {
        Text(self.text)
            .kerning(self.textStyle.kerning)
            .cafeoTextStyle(self.textStyle, state: self.state)
            .textCase(self.textStyle.textCase)
            .multilineTextAlignment(.center)
            .lineLimit(1)
    }
}
