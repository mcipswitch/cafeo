//
//  CafeoToggle.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-07-15.
//

import SwiftUI

struct CafeoToggle: View {
    @Binding var offset: CGFloat
    let toggleHeight: CGFloat = 40

    var body: some View {
        ZStack {
            self.togglePill
                .stroke(CommonAssets.Colors.cafeoShadowLight, lineWidth: 2)
                .frame(width: 100, height: self.toggleHeight)
                .background(
                    self.togglePill
                        .fill(CommonAssets.Colors.cafeoPrimaryBackgroundLight)

                        // outer shadow and highlight
                        .shadow(color: CommonAssets.Colors.cafeoShadowLight, radius: 4, x: 2, y: 2)
                        .shadow(color: CommonAssets.Colors.cafeoHighlightDark, radius: 4, x: -2, y: -2)
                )
                // inner shadow
                .shadow(color: CommonAssets.Colors.cafeoShadowLight, radius: 2, x: 2, y: 2)

            Circle()
                .stroke(CommonAssets.Colors.cafeoOrange, lineWidth: 2)
                .frame(width: self.toggleHeight, height: self.toggleHeight)
                .background(
                    Circle()
                        .fill(CommonAssets.Gradients.cafeoOrange)
                        .shadow(color: CommonAssets.Colors.cafeoShadowDark.opacity(0.6), radius: 14, x: 0, y: 0)
                )
                .offset(x: self.offset)
                .animation(Animation.timingCurve(0.60, 0.80, 0, 0.96), value: self.offset)
        }
    }

    private var togglePill: RoundedRectangle {
        RoundedRectangle(cornerRadius: CommonConstants.Spacing.spacing24, style: .continuous)
    }
}
