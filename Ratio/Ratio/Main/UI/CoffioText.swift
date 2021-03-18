//
//  CoffioText.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-03-13.
//

import SwiftUI

struct CoffioText: View {
    var text: String
    var textStyle: CoffioTextStyle
    var state: CoffioTextState

    init(text: String, state: CoffioTextState = .normal, _ textStyle: CoffioTextStyle) {
        self.text = text
        self.textStyle = textStyle
        self.state = state
    }

    var body: some View {
        Text(self.text)
            .kerning(self.textStyle.kerning)
            .coffioTextStyle(self.textStyle, state: self.state)
            .textCase(self.textStyle.textCase)
            .multilineTextAlignment(.center)
            .lineLimit(1)
    }
}
