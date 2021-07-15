//
//  CafeoUnitConversionView.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-11.
//

import ComposableArchitecture
import SwiftUI

struct CafeoUnitConversionView: View {
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>

    var body: some View {
        VStack(spacing: 16) {

            Text("conversion".localized)
                .kerning(1.5)
                .cafeoText(.miniLabel, color: .cafeoGray)
                .textCase(.uppercase)
                .padding(.horizontal, 8)
                .background(Color.cafeoBackgroundDark)
                .anchorPreference(
                    key: BoundsPreferenceKey.self,
                    value: .bounds,
                    transform: { $0 }
                )
                .backgroundPreferenceValue(BoundsPreferenceKey.self) { preferences in
                    GeometryReader { geo in
                        preferences.map { value in
                            Path { path in
                                path.move(to: CGPoint(x: -40,
                                                      y: 16))
                                path.addLine(to: CGPoint(x: -40,
                                                         y: geo[value].height/2))
                                path.addLine(to: CGPoint(x: geo[value].width + 40,
                                                         y: geo[value].height/2))
                                path.addLine(to: CGPoint(x: geo[value].width + 40,
                                                         y: 16))
                            }
                            .stroke(Color(#colorLiteral(red: 0.2862745098, green: 0.3058823529, blue: 0.3450980392, alpha: 1)), lineWidth: 1)
                        }
                    }
                }

            HStack(spacing: 30) {
                Text("\(CafeoUnit.grams.abbrString)")
                    .kerning(1.5)
                    .cafeoText(.unitLabel,
                               color: self.isGrams ? .cafeoOrange : .cafeoGray)
                    .textCase(.lowercase)
                    .accessibility(sortPriority: 1)
                    .accessibility(label: Text("grams"))

                CoffioToggle(
                    offset: self.viewStore.binding(
                        get: \.unitConversionToggleYOffset,
                        send: AppAction.unitConversionToggled
                    ))
                    .gesture(
                        // This registers both tap and swipe gestures
                        DragGesture(minimumDistance: 0)
                            .onEnded { _ in
                                self.viewStore.send(.unitConversionToggled)
                            }
                    )
                    .accessibility(sortPriority: 1)
                    .accessibility(label: Text("unit conversion toggle"))
                    .accessibility(value: Text("\(self.viewStore.unitConversion.rawValue)"))

                Text("\(CafeoUnit.ounces.abbrString)")
                    .kerning(1.5)
                    .cafeoText(.unitLabel,
                               color: self.isOunces ? .cafeoOrange : .cafeoGray)
                    .textCase(.lowercase)
                    .accessibility(sortPriority: 0)
                    .accessibility(label: Text("ounces"))
            }
            .accessibilityElement(children: .contain)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }

    // MARK: Helpers

    private var isGrams: Bool {
        return self.viewStore.unitConversion == .grams
    }

    private var isOunces: Bool {
        return self.viewStore.unitConversion == .ounces
    }
}

// MARK: - CoffioToggle

struct CoffioToggle: View {
    @Binding var offset: CGFloat
    var toggleHeight: CGFloat = 40

    var body: some View {
        ZStack {
            self.togglePill
                .stroke(Color.cafeoShadowDark1, lineWidth: 2)
                .frame(width: 100, height: self.toggleHeight)
                .background(
                    self.togglePill
                        .fill(Color.cafeoBackgroundLight)

                        // outer shadow and highlight
                        .shadow(color: .cafeoShadowDark1, radius: 4, x: 2, y: 2)
                        .shadow(color: .cafeoHighlight00, radius: 4, x: -2, y: -2)
                )
                // inner shadow
                .shadow(color: .cafeoShadowDark1, radius: 2, x: 2, y: 2)

            Circle()
                .stroke(Color.cafeoOrange, lineWidth: 2)
                .frame(width: self.toggleHeight, height: self.toggleHeight)
                .background(
                    Circle()
                        .fill(LinearGradient.cafeoOrange)
                        .shadow(color: Color.cafeoShadowDark00.opacity(0.6), radius: 14, x: 0, y: 0)
                )
                .offset(x: self.offset)
                .animation(Animation.timingCurve(0.60, 0.80, 0, 0.96), value: self.offset)
        }
    }

    private var togglePill: RoundedRectangle {
        RoundedRectangle(cornerRadius: .cafeo(.scale5), style: .continuous)
    }
}
