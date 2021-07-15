//
//  CafeoRatioView.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-11.
//

import ComposableArchitecture
import SwiftUI

struct CafeoRatioView: View {
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>
    var dividerWidth: CGFloat = 2

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                GeometryReader { geo in
                    self.ratioBox
                        .stroke(Color.cafeoShadowDark1, lineWidth: 2)
                        .background(self.ratioBox.fill(LinearGradient.cafeoChrome))

                    self.divider

                    HStack(spacing: 0) {
                        Text("1")
                            .kerning(4.0)
                            .cafeoText(.ratioLabel, color: .cafeoBeige)
                            .frame(
                                width: geo.size.width / 2,
                                height: geo.size.height
                            )
                            .addInnerShadow()
                        ZStack {
                            CafeoRatioSnapCarousel(viewStore: self.viewStore)
                                .animation(.spring())
                                .accessibilityElement(children: .ignore)
                                .accessibility(label: Text("Ratio is 1 to \(self.viewStore.activeRatioDenominator)"))
                            
                            self.ratioDenominatorLine
                                .frame(width: geo.size.width / 2 - self.dividerWidth)
                        }
                        .frame(
                            width: geo.size.width / 2,
                            height: geo.size.height
                        )
                        .addInnerShadow()

                        // Control the tappable area
                        .clipShape(Rectangle())
                        .contentShape(Rectangle())
                    }
                }
            }
            .accessibility(sortPriority: 0)

            Text("ratio".localized)
                .kerning(1.5)
                .cafeoText(.mainLabel, color: .cafeoGray)
                .textCase(.uppercase)
                .accessibility(sortPriority: 1)
        }
        .accessibilityElement(children: .contain)
    }

    // MARK: Helpers

    private var divider: some View {
        HStack {
            Spacer()
            Rectangle().frame(width: self.dividerWidth)
                .foregroundColor(.cafeoShadowDark1)
            Spacer()
        }
    }

    private var ratioBox: RoundedRectangle {
        RoundedRectangle(cornerRadius: .cafeo(.scale2
        ))
    }

    private var ratioDenominatorLine: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.cafeoOrange)
                .shadow(color: .black05, radius: 2, x: 0, y: 1)

            // highlight
            Rectangle().frame(height: 1)
                .foregroundColor(.white03)
                .blur(radius: 1)
        }
        .frame(height: 2)
    }
}
