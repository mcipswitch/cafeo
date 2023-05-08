//
//  View+Extension.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-10.
//

import SwiftUI

extension View {
    func cafeoInnerShadow(
        _ color: Color = CommonAssets.Colors.cafeoShadowLight,
        lineWidth: CGFloat = 4,
        blurRadius: CGFloat = 10
    ) -> some View {
        self.overlay(
            Rectangle()
                .strokeBorder(color, lineWidth: lineWidth)
                .blur(radius: blurRadius)
        )
    }
}
