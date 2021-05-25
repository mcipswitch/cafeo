//
//  AddMinusButton.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-09.
//

import SwiftUI

struct IngredientAdjustButton: View {
    var onPress: (IngredientAction) -> Void
    var onRelease: () -> Void
    var onTap: (IngredientAction) -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .stroke(LinearGradient.cafeoIngredientAmountButtonStroke, lineWidth: 2)
                .frame(width: 120, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.cafeoBackgroundLight)

                        // highlight and shadow
                        .shadow(color: .cafeoHighlight1, radius: 8, x: -4, y: -4)
                        .shadow(color: .cafeoShadowDark00, radius: 8, x: 4, y: 4)
                )
                .overlay(
                    HStack(spacing: 0) {
                        AdjustButton(Image(systemName: "minus")) {
                            self.onTap(.decrement)
                        }
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 0.2)
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

                        AdjustButton(Image(systemName: "plus")) {
                            self.onTap(.increment)
                        }
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 0.2)
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
                    .padding(.horizontal, 6)
                )
        }
    }
}

// MARK: - AdjustButton

struct AdjustButton: View {
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
        .frame(width: 44, height: 44)
        .contentShape(Rectangle())
        .cafeoTextStyle(.adjustButtonLabel)
    }
}

// MARK: - Previews

struct AmountAdjustButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .fill(Color.cafeoBackgroundLight)

            IngredientAdjustButton(
                onPress: { _ in },
                onRelease: { },
                onTap: { _ in }
            )
        }
        .edgesIgnoringSafeArea(.all)
    }
}
