//
//  AddMinusButton.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-03-09.
//

import SwiftUI

struct IncrementDecrementButton: View {
    var incrementAction: () -> Void
    var decrementAction: () -> Void

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
                    HStack {
                        Image(systemName: "minus")
                            .onTapGesture {
                                self.decrementAction()
                            }

                        Spacer()

                        Image(systemName: "plus")
                            .onTapGesture {
                                self.incrementAction()
                            }
                    }
                    .font(Font.custom("Orbitron-Medium", fixedSize: 16))
                    .foregroundColor(.coffioGray)
                    .padding(.horizontal, 20)
                )
        }
    }
}
