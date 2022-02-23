//
//  CafeoRatioSnapCarousel.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-04-15.
//

import ComposableArchitecture
import SwiftUI

/// Please see: https://medium.com/flawless-app-stories/implementing-snap-carousel-in-swiftui-3ae084504670
struct CafeoRatioSnapCarousel: View {
    let store: Store<AppState, AppAction>

    @ObservedObject var viewStore: ViewStore<AppState, AppAction>

    var height: CGFloat = .zero

    init(store: Store<AppState, AppAction>, height: CGFloat) {
        self.store = store
        self.viewStore = ViewStore<AppState, AppAction>(self.store)
        self.height = height
    }

    @GestureState var dragOffset = CGFloat.zero

    var body: some View {

        let itemHeight: CGFloat = self.height
        let numberOfItems: CGFloat = CGFloat(viewStore.ratioDenominators.count)
        let totalHeight: CGFloat = itemHeight * numberOfItems
        let yOffsetToShift: CGFloat = (totalHeight - itemHeight) / 2
        let activeOffset: CGFloat = yOffsetToShift - (itemHeight * CGFloat(viewStore.settings.activeRatioIdx))
        let totalOffset: CGFloat = CGFloat(activeOffset) + self.dragOffset

        VStack(spacing: 0) {
            ForEach(viewStore.ratioDenominators, id: \.self) { ratioDenom in
                Text("\(ratioDenom)")
                    .kerning(.cafeo(.large))
                    .cafeoText(.ratioLabel, color: .cafeoBeige)
                    .frame(width: itemHeight * 2, height: itemHeight)
                    .contentShape(Rectangle()) /* control tappable area */
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
                        let newIdx = (viewStore.settings.activeRatioIdx - idxOffset)
                            .clamp(low: 0, high: viewStore.ratioDenominators.count - 1)

                        viewStore.send(.setActiveRatioIdx(index: newIdx))
                    }
                }
        )
    }
}
