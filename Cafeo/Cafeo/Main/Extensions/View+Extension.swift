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

    /// Applies the corresponding Cafeo text attributes
    func cafeoText(_ fontStyle: CafeoFontStyle, color: Color) -> some View {
        self.font(.cafeo(fontStyle))
            .foregroundColor(.cafeo(color))
    }
}
