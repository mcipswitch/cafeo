//
//  RatioSnapCarousel.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-04-15.
//

import ComposableArchitecture
import SwiftUI

/// Please see: https://medium.com/flawless-app-stories/implementing-snap-carousel-in-swiftui-3ae084504670
struct RatioSnapCarousel: View {
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>
    @GestureState var dragOffset = CGFloat.zero

    var body: some View {

        let itemHeight: CGFloat = 80
        let numberOfItems: CGFloat = CGFloat(self.viewStore.ratioDenominators.count)
        let totalHeight: CGFloat = itemHeight * numberOfItems

        let yOffsetToShift: CGFloat = (totalHeight - itemHeight) / 2
        let activeOffset: CGFloat = yOffsetToShift - (itemHeight * CGFloat(self.viewStore.ratioCarouselActiveIdx))
        let totalOffset: CGFloat = CGFloat(activeOffset) + self.dragOffset

        VStack {
            ForEach(self.viewStore.ratioDenominators, id: \.self) { ratioDenom in
                CafeoText(text: "\(ratioDenom)", .ratioLabel)
                    .frame(width: itemHeight * 2, height: itemHeight)

                    // Control the tappable area
                    .contentShape(Rectangle())
            }
        }
        .offset(y: totalOffset)
        .gesture(
            DragGesture()
                .updating(self.$dragOffset) { value, state, transaction in
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
                        let newIdx = (self.viewStore.ratioCarouselActiveIdx - idxOffset)
                            .clamp(low: 0, high: self.viewStore.ratioDenominators.count - 1)

                        self.viewStore.send(.form(.set(\.ratioCarouselActiveIdx, newIdx)))
                    }
                }
        )
    }
}
