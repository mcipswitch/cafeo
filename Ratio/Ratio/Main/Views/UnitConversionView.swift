//
//  UnitConversionView.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-03-11.
//

import ComposableArchitecture
import SwiftUI

struct UnitConversionView: View {
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>
    @State private var toggleOffset: CGFloat = -100/2 + (42/2)

    var body: some View {
        VStack(spacing: 16) {

            CoffioText(text: "conversion", .miniLabel)
                .padding(.horizontal, 8)
                .background(Color.coffioBackgroundDark)
                .anchorPreference(
                    key: SizePrefKey.self,
                    value: .bounds,
                    transform: { $0 }
                )
                .backgroundPreferenceValue(SizePrefKey.self) { prefs in
                    GeometryReader { geometry in
                        prefs.map { value in
                            Path { path in
                                path.move(to: CGPoint(x: -40,
                                                      y: 16))
                                path.addLine(to: CGPoint(x: -40,
                                                         y: geometry[value].height/2))
                                path.addLine(to: CGPoint(x: geometry[value].width + 40,
                                                         y: geometry[value].height/2))
                                path.addLine(to: CGPoint(x: geometry[value].width + 40,
                                                         y: 16))
                            }
                            .stroke(Color.coffioGray, lineWidth: 1)
                        }
                    }
                }

            HStack(spacing: 30) {
                CoffioText(text: "\(UnitMass.grams.abbrString)", .unitLabel)

                // Toggle
                ZStack {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color(#colorLiteral(red: 0.09411764706, green: 0.09803921569, blue: 0.1019607843, alpha: 1)), lineWidth: 2)
                        .frame(width: 100, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(Color.coffioBackgroundLight)
                                .shadow(color: Color(#colorLiteral(red: 0.09411764706, green: 0.09803921569, blue: 0.1019607843, alpha: 1)), radius: 4, x: 2, y: 2)
                        )
                        .shadow(color: Color(#colorLiteral(red: 0.09411764706, green: 0.09803921569, blue: 0.1019607843, alpha: 1)), radius: 2, x: 2, y: 2)

                    Circle()
                        .stroke(Color.coffioOrange, lineWidth: 2)
                        .frame(width: 42, height: 42)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient:
                                            Gradient(colors: [Color(#colorLiteral(red: 0.5568627451, green: 0.2, blue: 0, alpha: 1)), Color(#colorLiteral(red: 0.8980392157, green: 0.3803921569, blue: 0, alpha: 1))]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: Color(#colorLiteral(red: 0.09411764706, green: 0.09803921569, blue: 0.1019607843, alpha: 1)), radius: 14, x: 4, y: 4)
                        )
                        .offset(x: self.viewStore.toggleOffset)

                }
                .onTapGesture {
                    self.viewStore.send(.toggleUnitConversion, animation: Animation.timingCurve(0.60, 0.80, 0, 0.94))
                }

                CoffioText(text: "\(UnitMass.ounces.abbrString)", .unitLabel)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}
