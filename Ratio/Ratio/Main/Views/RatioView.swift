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
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(#colorLiteral(red: 0.09411764706, green: 0.09803921569, blue: 0.1019607843, alpha: 1)), style: StrokeStyle(lineWidth: 2))
                            .mask(RoundedRectangle(cornerRadius: 8))
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color(#colorLiteral(red: 0.137254902, green: 0.1490196078, blue: 0.168627451, alpha: 1)), Color(#colorLiteral(red: 0.2431372549, green: 0.262745098, blue: 0.2941176471, alpha: 1)), Color(#colorLiteral(red: 0.137254902, green: 0.1490196078, blue: 0.168627451, alpha: 1))]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                            )
                            // Inner shadow
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(#colorLiteral(red: 0.09411764706, green: 0.09803921569, blue: 0.1019607843, alpha: 1)), style: StrokeStyle(lineWidth: 2))
                                    .blur(radius: 4)
                                    .frame(width: geo.size.width - 4, height: geo.size.height - 4)
                            )

                        HStack {
                            Spacer()
                            Rectangle().frame(width: self.dividerWidth)
                                .foregroundColor(.coffioShadow)
                            Spacer()
                        }

                        HStack(spacing: 0) {
                            CoffioText(text: "1", .ratioLabel)
                                .frame(
                                    width: geo.size.width/2,
                                    height: geo.size.height
                                )

                            ZStack {
                                SnapCarousel(viewStore: self.viewStore)
                                    // TODO: - could this be animated in appstate?????
                                    .animation(.spring())

                                self.ratioDenominatorLine
                                    .frame(width: geo.size.width / 2 - self.dividerWidth)
                            }
                            .frame(
                                width: geo.size.width / 2,
                                height: geo.size.height
                            )
//                            .mask(
//                                RoundedRectangle(cornerRadius: 50)
//                                    .frame(
//                                        width: geo.size.width / 2,
//                                        height: geo.size.height - 2
//                                    )
//                            )
                        }
                }
            }

            CoffioText(text: "ratio", .mainLabel)
        }
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
struct SnapCarousel: View {
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>
    @GestureState var dragOffset = CGFloat.zero

    var body: some View {

        let cardHeight: CGFloat = 80
        let numberOfItems: CGFloat = CGFloat(self.viewStore.ratioDenominators.count)

        let totalCanvasHeight: CGFloat = cardHeight * numberOfItems
        let yOffsetToShift: CGFloat = (totalCanvasHeight - cardHeight) / 2

        let activeOffset: CGFloat = yOffsetToShift - (cardHeight * CGFloat(self.viewStore.activeRatioIdx))

        var calcOffset: CGFloat = CGFloat(activeOffset) + self.dragOffset

        VStack {
            ForEach(0 ..< self.viewStore.ratioDenominators.count) { idx in
                CoffioText(text: "\(self.viewStore.ratioDenominators[idx])", .ratioLabel)
                    .frame(height: cardHeight)
            }
        }

        .offset(y: CGFloat(calcOffset))
        .gesture(
            DragGesture()
                .updating($dragOffset) { value, state, transaction in
                    state = value.translation.height
                }
                .onEnded { drag in
                    let dragAmount = drag.translation.height

                    // Calculate the index shift to the closest entry
                    let idxOffset = Int(round(dragAmount / cardHeight))

                    if (dragAmount < cardHeight/2 || dragAmount > cardHeight/2) {
                        let newIdx = (self.viewStore.activeRatioIdx - idxOffset).clamp(low: 0, high: self.viewStore.ratioDenominators.count - 1)

                        self.viewStore.send(.form(.set(\.activeRatioIdx, newIdx)))
                        self.feedback()
                    }
                }
        )
    }

    private func feedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}


