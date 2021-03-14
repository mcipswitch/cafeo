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
                           state: self.viewStore.conversionUnit == .grams ? .selected : .normal,
                           .unitLabel)

                CoffioToggle(
                    offset: self.viewStore.binding(
                        keyPath: \.toggleYOffset,
                        send: AppAction.form
                    ))
                    .gesture(
                        // This registers tap and swipe gestures
                        DragGesture(minimumDistance: 0)
                            .onEnded { value in
                                self.viewStore.send(
                                    .unitConversionToggleYOffsetChanged,
                                    animation: Animation.timingCurve(0.60, 0.80, 0, 0.96)
                                )
                            }
                    )

                CoffioText(text: "\(UnitMass.ounces.abbrString)",
                           state: self.viewStore.conversionUnit == .ounces ? .selected : .normal,
                           .unitLabel)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}

struct CoffioToggle: View {
    @Binding var offset: CGFloat
    var toggleHeight: CGFloat = 40

    var body: some View {
        ZStack {
            self.togglePill
                .stroke(Color.coffioShadowDark1, lineWidth: 2)
                .frame(width: 100, height: self.toggleHeight)
                .background(
                    self.togglePill
                        .fill(Color.coffioBackgroundLight)
                        // outer shadow and highlight
                        .shadow(color: .coffioShadowDark1, radius: 4, x: 2, y: 2)
                        .shadow(color: .coffioHighlight00, radius: 4, x: -2, y: -2)
                )
                // inner shadow
                .shadow(color: .coffioShadowDark1, radius: 2, x: 2, y: 2)

            Circle()
                .stroke(Color.coffioOrange, lineWidth: 2)
                .frame(width: self.toggleHeight, height: self.toggleHeight)
                .background(
                    Circle()
                        .fill(LinearGradient.coffioOrange)
                        .shadow(color: Color.coffioShadowDark00.opacity(0.6), radius: 14, x: 0, y: 0)
                )
                .offset(x: self.offset)
        }
    }

    var togglePill: RoundedRectangle {
        RoundedRectangle(cornerRadius: 24, style: .continuous)
    }
}
