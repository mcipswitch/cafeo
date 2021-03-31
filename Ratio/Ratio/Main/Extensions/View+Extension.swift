//
//  View+Extension.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-03-10.
//

import SwiftUI

extension View {
    func inverseMask<Mask>(_ mask: Mask) -> some View where Mask: View {
        self.mask(
            mask
                .foregroundColor(.black)
                .background(Color.white)
                .compositingGroup()
                .luminanceToAlpha()
        )
    }

    func addInnerShadow(_ color: Color = Color.coffioShadowDark1, lineWidth: CGFloat = 4, blurRadius: CGFloat = 10) -> some View {
        self.overlay(
            Rectangle()
                .strokeBorder(color, lineWidth: lineWidth)
                .blur(radius: blurRadius)
        )
    }

    func coffioTextStyle(_ textStyle: CoffioTextStyle, state: CoffioTextState = .normal) -> some View {
        return self.modifier(CoffioTextModifier(textStyle, state: state))
    }
}
