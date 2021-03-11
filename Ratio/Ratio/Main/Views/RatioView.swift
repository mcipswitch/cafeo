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

    var ratioDenominatorLine: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.coffioOrange)
                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 1)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.white.opacity(0.3))
                .blur(radius: 1)
        }
        .frame(height: 2)
    }

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
                            Rectangle()
                                .frame(width: 2)
                                .foregroundColor(Color(#colorLiteral(red: 0.09411764706, green: 0.09803921569, blue: 0.1019607843, alpha: 1)))
                            Spacer()
                        }
                        HStack(spacing: 0) {
                            Text("1").kerning(4.0)
                                .coffioTextStyle(.ratioLabel)
                                .frame(
                                    width: geo.size.width/2,
                                    height: geo.size.height
                                )

                            ZStack {
                                VStack(spacing: 8) {
                                    Text("\(self.viewStore.ratioDenominator - 1, specifier: "%.0f")").kerning(4)
                                    Text("\(self.viewStore.ratioDenominator, specifier: "%.0f")").kerning(4)
                                    Text("\(self.viewStore.ratioDenominator + 1, specifier: "%.0f")").kerning(4)
                                }
                                .coffioTextStyle(.ratioLabel)

                                self.ratioDenominatorLine
                                    .frame(width: geo.size.width / 2 - 2)
                            }
                            .frame(
                                width: geo.size.width/2,
                                height: geo.size.height
                            )
                            .mask(
                                RoundedRectangle(cornerRadius: 50)
                                    .frame(
                                        width: geo.size.width / 2,
                                        height: geo.size.height - 2
                                    )
                            )
                        }
                }
            }

            CoffioText(text: "ratio: classic", .mainLabel)
        }
    }
}

struct CoffioText: View {
    var text: String
    var textStyle: CoffioTextStyle

    init(text: String, _ textStyle: CoffioTextStyle) {
        self.text = text
        self.textStyle = textStyle
    }

    var body: some View {
        Text(self.text)
            .kerning(self.textStyle.kerning)
            .coffioTextStyle(self.textStyle)
            .textCase(self.textStyle.textCase)
    }
}
