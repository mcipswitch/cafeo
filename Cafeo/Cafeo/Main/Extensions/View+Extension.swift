//
//  View+Extension.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-10.
//

import SwiftUI

extension View {
    func addInnerShadow(
        _ color: Color = .cafeoShadowDark1,
        lineWidth: CGFloat = 4,
        blurRadius: CGFloat = 10
    ) -> some View {
        self.overlay(
            Rectangle()
                .strokeBorder(color, lineWidth: lineWidth)
                .blur(radius: blurRadius)
        )
    }

    func cafeoTextStyle(_ textStyle: CafeoTextStyle, state: CafeoTextState = .normal) -> some View {
        return self.modifier(CafeoTextModifier(textStyle, state: state))
    }
}
