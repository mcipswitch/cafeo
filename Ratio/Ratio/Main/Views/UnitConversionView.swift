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
                    key: BoundsPreferenceKey.self,
                    value: .bounds,
                    transform: { $0 }
                )
                .backgroundPreferenceValue(BoundsPreferenceKey.self) { preferences in
                    GeometryReader { geometry in
                        preferences.map { value in
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
                            .stroke(Color(#colorLiteral(red: 0.2862745098, green: 0.3058823529, blue: 0.3450980392, alpha: 1)), lineWidth: 1)
                        }
                    }
                }

            HStack(spacing: 30) {
                CoffioText(text: "\(UnitMass.grams.abbrString)",
                           state: self.viewStore.unit == .grams ? .selected : .normal,
                           .unitLabel)

                CoffioToggle(
                    offset: self.viewStore.binding(
                        keyPath: \.toggleOffset,
                        send: AppAction.form
                    ))
                    .onTapGesture {
                        self.viewStore.send(.toggleUnitConversion, animation: Animation.timingCurve(0.60, 0.80, 0, 0.96))
                    }

                CoffioText(text: "\(UnitMass.ounces.abbrString)",
                           state: self.viewStore.unit == .ounces ? .selected : .normal,
                           .unitLabel)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}

struct CoffioToggle: View {
    @Binding var offset: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color(#colorLiteral(red: 0.09411764706, green: 0.09803921569, blue: 0.1019607843, alpha: 1)), lineWidth: 2)
                .frame(width: 100, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.coffioBackgroundLight)
                        .shadow(color: Color(#colorLiteral(red: 0.09411764706, green: 0.09803921569, blue: 0.1019607843, alpha: 1)), radius: 4, x: 2, y: 2)
                        .shadow(color: Color(#colorLiteral(red: 0.1607843137, green: 0.1725490196, blue: 0.1960784314, alpha: 1)), radius: 4, x: -2, y: -2)
                )
                // inner shadow
                .shadow(color: Color(#colorLiteral(red: 0.09411764706, green: 0.09803921569, blue: 0.1019607843, alpha: 1)), radius: 2, x: 2, y: 2)

            Circle()
                .stroke(Color.coffioOrange, lineWidth: 2)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(LinearGradient.coffioOrange)
                        .shadow(color: Color(#colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.01568627451, alpha: 1)).opacity(0.6), radius: 14, x: 0, y: 0)
                )
                .offset(x: self.offset)
        }
    }
}
