//
//  AddMinusButton.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-09.
//

import SwiftUI

struct IngredientAmountButton: View {
    var onPress: (IngredientAction) -> Void
    var onRelease: () -> Void
    var onTap: (IngredientAction) -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .stroke(
                    LinearGradient(
                        gradient:
                            Gradient(colors: [Color.cafeoBackgroundDark, Color(#colorLiteral(red: 0.1960784314, green: 0.2117647059, blue: 0.231372549, alpha: 1))]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
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
                        Button(action: {
                            self.onTap(.decrement)
                        }, label: {
                            Image(systemName: "minus")
                        })
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 0.2)
                                .onEnded { _ in
                                    self.onPress(.decrement)
                                }
                        )
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .onEnded { _ in
                                    // This is triggered by the end of a long press gesture
                                    self.onRelease()
                                }
                        )

                        Spacer()

                        Button(action: {
                            self.onTap(.increment)
                        }, label: {
                            Image(systemName: "plus")
                        })
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 0.2)
                                .onEnded { _ in
                                    self.onPress(.increment)
                                }
                        )
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .onEnded { _ in
                                    // This is triggered by the end of a long press gesture
                                    self.onRelease()
                                }
                        )



                    }
                    .font(Font.custom("Orbitron-Medium", fixedSize: 16))
                    .foregroundColor(.cafeoGray)
                    .padding(.horizontal, 6)
                )
        }
    }
}

// MARK: - Previews

struct AmountAdjustButton_Previews: PreviewProvider {
    static var previews: some View {
    }
}
