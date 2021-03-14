//
//  AddMinusButton.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-03-09.
//

import SwiftUI

struct AmountAdjustButton: View {
    var onPress: (AdjustAmountAction) -> Void
    var onRelease: () -> Void
    var onTap: (AdjustAmountAction) -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .stroke(
                    LinearGradient(
                        gradient:
                            Gradient(colors: [Color.coffioBackgroundDark, Color(#colorLiteral(red: 0.1960784314, green: 0.2117647059, blue: 0.231372549, alpha: 1))]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
                .frame(width: 120, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.coffioBackgroundLight)
                        .shadow(color: Color(#colorLiteral(red: 0.2470588235, green: 0.262745098, blue: 0.2901960784, alpha: 1)), radius: 8, x: -4, y: -4)
                        .shadow(color: Color(#colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.01568627451, alpha: 1)), radius: 8, x: 4, y: 4)
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
                    .foregroundColor(.coffioGray)
                    .padding(.horizontal, 6)
                )
        }
    }
}

//struct CoffioAmountAdjustmentButton: ButtonStyle {
//    var isSelected: Bool = false
//
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
////            .foregroundColor(
////                configuration.isPressed
////                    ? .white
////                    : .coffioGray
////            )
//            .scaleEffect(configuration.isPressed ? 1.5 : 1.0)
//            .animation(.easeInOut(duration: 0.4), value: configuration.isPressed)
//    }
//}
