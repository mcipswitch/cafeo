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
                .stroke(Color.cafeoShadowDark1, lineWidth: 2)
                .frame(width: 100, height: self.toggleHeight)
                .background(
                    self.togglePill
                        .fill(Color.cafeoBackgroundLight)

                        // outer shadow and highlight
                        .shadow(color: .cafeoShadowDark1, radius: 4, x: 2, y: 2)
                        .shadow(color: .cafeoHighlight00, radius: 4, x: -2, y: -2)
                )
                // inner shadow
                .shadow(color: .cafeoShadowDark1, radius: 2, x: 2, y: 2)

            Circle()
                .stroke(Color.cafeoOrange, lineWidth: 2)
                .frame(width: self.toggleHeight, height: self.toggleHeight)
                .background(
                    Circle()
                        .fill(LinearGradient.cafeoOrange)
                        .shadow(color: Color.cafeoShadowDark00.opacity(0.6), radius: 14, x: 0, y: 0)
                )
                .offset(x: self.offset)
                .animation(Animation.timingCurve(0.60, 0.80, 0, 0.96), value: self.offset)
        }
    }

    private var togglePill: RoundedRectangle {
        RoundedRectangle(cornerRadius: .cafeo(.scale5), style: .continuous)
    }
}
