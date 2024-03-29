//
//  CafeoUnitConversionView.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-11.
//

import ComposableArchitecture
import SwiftUI

struct CafeoUnitConversionView: View {
    let store: Store<AppState, AppAction>

    struct ViewState: Equatable {
        let settings: AppState.PresetSettings
        let toggleYOffset: CGFloat

        init(state: AppState) {
            self.settings = state.settings
            self.toggleYOffset = state.settings.unitConversion.toggleYOffset
        }
    }

    var body: some View {
        WithViewStore(self.store.scope(state: ViewState.init)) { viewStore in
            VStack(spacing: CommonConstants.Spacing.spacing16) {
                Text(CommonStrings.conversion.localizedUppercase)
                    .kerning(CommonConstants.Kerning.standard)
                    .cafeoText(.miniLabel, color: CommonAssets.Colors.cafeoGray)
                    .padding(.horizontal, CommonConstants.Spacing.spacing8)
                    .background(CommonAssets.Colors.cafeoPrimaryBackgroundDark)
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

                HStack(spacing: CommonConstants.Spacing.spacing30) {
                    UnitLabel(.grams, isSelected: viewStore.settings.unitConversion == .grams)
                        .accessibility(sortPriority: 1)
                        .accessibility(label: Text("grams"))

                    CafeoToggle(
                        offset: viewStore.binding(
                            get: \.toggleYOffset,
                            send: .unitConversionToggled
                        ))
                        .gesture(
                            // This registers both tap and swipe gestures
                            DragGesture(minimumDistance: 0)
                                .onEnded { _ in viewStore.send(.unitConversionToggled) }
                        )
                        .accessibility(sortPriority: 1)
                        .accessibility(label: Text("unit conversion toggle"))
                        .accessibility(value: Text(viewStore.settings.unitConversion.rawValue))

                    UnitLabel(.ounces, isSelected: viewStore.settings.unitConversion == .ounces)
                        .accessibility(sortPriority: 0)
                        .accessibility(label: Text("ounces"))
                }
                .accessibilityElement(children: .contain)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
        }
    }
}

private extension CafeoUnitConversionView {
    struct UnitLabel: View {
        var unit: CafeoUnit
        var isSelected: Bool

        init(_ unit: CafeoUnit, isSelected: Bool) {
            self.unit = unit
            self.isSelected = isSelected
        }

        var body: some View {
            Text(unit.abbrString)
                .kerning(CommonConstants.Kerning.standard)
                .cafeoText(.unitLabel, color: self.isSelected ? CommonAssets.Colors.cafeoOrange : CommonAssets.Colors.cafeoGray)
                .textCase(.lowercase)
        }
    }
}
