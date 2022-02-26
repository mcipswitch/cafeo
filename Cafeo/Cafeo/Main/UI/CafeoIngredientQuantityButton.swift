//
//  CafeoIngredientQuantityButton.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-09.
//

import ComposableArchitecture
import SwiftUI

struct CafeoIngredientQuantityButton: View {
    let store: Store<CafeoIngredientQuantityButtonDomain.State, CafeoIngredientQuantityButtonDomain.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                RoundedRectangle(cornerRadius: .cafeo(.spacing24), style: .continuous)
                    .stroke(LinearGradient.cafeoIngredientAmountButtonStroke, lineWidth: 2)
                    .clipShape(RoundedRectangle(cornerRadius: .cafeo(.spacing24), style: .continuous))
                    .frame(width: 120, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: .cafeo(.spacing24), style: .continuous)
                            .fill(Color.cafeoPrimaryBackgroundLight)
                        // highlight and shadow
                            .shadow(color: .cafeoHighlightLight, radius: 8, x: -4, y: -4)
                            .shadow(color: .cafeoShadowDark, radius: 8, x: 4, y: 4)
                    )
                    .overlay(
                        HStack(spacing: 0) {
                            CafeoQuantityStepperButton(Image.cafeo(.minus)) {
                                viewStore.send(.onTap(step: .decrement))
                            }
                            .simultaneousGesture(
                                LongPressGesture(minimumDuration: 0)
                                    .onEnded { _ in
                                        viewStore.send(.onPress(step: .decrement))
                                    }
                            )
                            .simultaneousGesture(
                                DragGesture(minimumDistance: 0)
                                    .onEnded { _ in
                                        // This is triggered by the end of a long press gesture
                                        viewStore.send(.onRelease)
                                    }
                            )

                            Spacer()

                            CafeoQuantityStepperButton(Image.cafeo(.plus)) {
                                viewStore.send(.onTap(step: .increment))
                            }
                            .simultaneousGesture(
                                LongPressGesture(minimumDuration: 0)
                                    .onEnded { _ in
                                        viewStore.send(.onPress(step: .increment))
                                    }
                            )
                            .simultaneousGesture(
                                DragGesture(minimumDistance: 0)
                                    .onEnded { _ in
                                        // This is triggered by the end of a long press gesture
                                        viewStore.send(.onRelease)
                                    }
                            )
                        }.padding(.horizontal, .cafeo(.spacing6))
                    )
            }
        }
    }
}

// MARK: - CafeoQuantityStepperButton

struct CafeoQuantityStepperButton: View {
    var action: () -> Void
    var image: Image

    init(_ image: Image, action: @escaping () -> Void) {
        self.action = action
        self.image = image
    }

    var body: some View {
        Button(action: self.action) {
            self.image
        }
        .contentShape(Rectangle())
        .cafeoButtonStyle(
            .init(
                labelFont: .quantityStepperLabel,
                labelColor: .quantityStepper,
                backgroundColor: .clear,
                size: CGSize(width: 44, height: 44)
            )
        )
    }
}
