//
//  CafeoIngredientQuantityButton.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-09.
//

import SwiftUI

struct CafeoIngredientQuantityButton: View {
    var onPress: (IngredientAction) -> Void
    var onRelease: () -> Void
    var onTap: (IngredientAction) -> Void

    var body: some View {

        ZStack {
            RoundedRectangle(cornerRadius: .cafeo(.spacing24), style: .continuous)
                .stroke(LinearGradient.cafeoIngredientAmountButtonStroke, lineWidth: 2)
                .clipShape(RoundedRectangle(cornerRadius: .cafeo(.spacing24), style: .continuous))
                .frame(width: 120, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: .cafeo(.spacing24), style: .continuous)
                        .fill(Color.primaryBackgroundLight)
                        // highlight and shadow
                        .shadow(color: .cafeoHighlight1, radius: 8, x: -4, y: -4)
                        .shadow(color: .cafeoShadowDark00, radius: 8, x: 4, y: 4)
                )
                .overlay(
                    HStack(spacing: 0) {
                        CafeoQuantityStepperButton(Image.cafeo(.minus)) {
                            self.onTap(.decrement)
                        }
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 0)
                                .onEnded { _ in self.onPress(.decrement) }
                        )
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .onEnded { _ in
                                    // This is triggered by the end of a long press gesture
                                    self.onRelease()
                                }
                        )

                        Spacer()

                        CafeoQuantityStepperButton(Image.cafeo(.plus)) {
                            self.onTap(.increment)
                        }
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 0)
                                .onEnded { _ in self.onPress(.increment) }
                        )
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .onEnded { _ in
                                    // This is triggered by the end of a long press gesture
                                    self.onRelease()
                                }
                        )
                    }
                    .padding(.horizontal, .cafeo(.spacing6))
                )
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
                labelFont: .adjustButtonLabel,
                labelColor: .quantityStepper,
                backgroundColor: .clear,
                size: CGSize(width: 44, height: 44)
            )
        )
    }
}
