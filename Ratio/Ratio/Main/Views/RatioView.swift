//
//  RatioView.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-03-11.
//

import ComposableArchitecture
import SwiftUI

struct RatioView: View {
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>
    var dividerWidth: CGFloat = 2

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                GeometryReader { geo in
                    self.ratioBox
                        .stroke(Color.coffioShadowDark1, lineWidth: 2)
                        .background(
                            self.ratioBox
                                .fill(LinearGradient.coffioChrome)
                        )
                        // inner shadow
                        .overlay(
                            self.ratioBox
                                .stroke(Color.coffioShadowDark1, lineWidth: 2)
                                .blur(radius: 4)
                                .frame(
                                    width: geo.size.width - 4,
                                    height: geo.size.height - 4
                                )
                        )
                    HStack {
                        Spacer()
                        Rectangle().frame(width: self.dividerWidth)
                            .foregroundColor(.coffioShadowDark1)
                        Spacer()
                    }
                    HStack(spacing: 0) {
                        CoffioText(text: "1", .ratioLabel)
                            .frame(
                                width: geo.size.width / 2,
                                height: geo.size.height
                            )
                        ZStack {
                            RatioSnapCarousel(viewStore: self.viewStore)
                                // TODO: - This could be animated in AppState in the future
                                .animation(.spring())

                            self.ratioDenominatorLine
                                .frame(width: geo.size.width / 2 - self.dividerWidth)
                        }
                        .frame(
                            width: geo.size.width / 2,
                            height: geo.size.height
                        )
                        // Control the tappable area
                        .clipShape(Rectangle())
                        .contentShape(Rectangle())
                    }
                }
            }
            CoffioText(text: "ratio", .mainLabel)
        }
    }

    var ratioBox: RoundedRectangle {
        RoundedRectangle(cornerRadius: 8)
    }

    var ratioDenominatorLine: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.coffioOrange)
                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 1)

            // highlight
            Rectangle().frame(height: 1)
                .foregroundColor(Color.white.opacity(0.3))
                .blur(radius: 1)
        }
        .frame(height: 2)
    }
}

/// Please see: https://medium.com/flawless-app-stories/implementing-snap-carousel-in-swiftui-3ae084504670
struct RatioSnapCarousel: View {
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>
    @GestureState var dragOffset = CGFloat.zero

    var body: some View {

        let itemHeight: CGFloat = 80
        let numberOfItems: CGFloat = CGFloat(self.viewStore.ratioDenominators.count)
        let totalHeight: CGFloat = itemHeight * numberOfItems

        let yOffsetToShift: CGFloat = (totalHeight - itemHeight) / 2
        let activeOffset: CGFloat = yOffsetToShift - (itemHeight * CGFloat(self.viewStore.activeRatioIdx))
        let totalOffset: CGFloat = CGFloat(activeOffset) + self.dragOffset

        VStack {
            ForEach(self.viewStore.ratioDenominators, id: \.self) { ratioDenom in
                CoffioText(text: "\(ratioDenom)", .ratioLabel)
                    .frame(width: itemHeight * 2, height: itemHeight)
                    // Control the tappable area
                    .contentShape(Rectangle())
            }
        }
        .offset(y: totalOffset)
        .gesture(
            DragGesture()
                .updating($dragOffset) { value, state, transaction in
                    state = value.translation.height
                }
                .onEnded { drag in
                    let dragAmount = drag.translation.height

                    // Calculate the index shift to the closet ratio denominator
                    let idxOffset = Int(round(dragAmount / itemHeight))

                    var dragAmountThresholdPassed: Bool {
                        dragAmount < itemHeight / 2 || dragAmount > itemHeight / 2
                    }

                    if dragAmountThresholdPassed {
                        let newIdx = (self.viewStore.activeRatioIdx - idxOffset)
                            .clamp(low: 0, high: self.viewStore.ratioDenominators.count - 1)

                        self.viewStore.send(.form(.set(\.activeRatioIdx, newIdx)))
                    }
                }
        )
    }
}
