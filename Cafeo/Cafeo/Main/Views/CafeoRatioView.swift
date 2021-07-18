//
//  CafeoRatioView.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-11.
//

import ComposableArchitecture
import SwiftUI

struct CafeoRatioView: View {
    let store: Store<AppState, AppAction>

    @State private var showSavedPresets = false
    @State private var showSavePresetAlert = false

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(spacing: .cafeo(.scale45)) {
                ZStack {
                    GeometryReader { geo in
                        self.ratioBox
                            .stroke(Color.cafeoShadowDark1, lineWidth: 2)
                            .background(self.ratioBox.fill(LinearGradient.cafeoChrome))

                        Divider()

                        HStack(spacing: 0) {
                            Text("1")
                                .cafeoText(.ratioLabel, color: .cafeoBeige)
                                .frame(width: geo.size.width / 2,
                                       height: geo.size.height)
                                .cafeoInnerShadow()

                            ZStack {
                                CafeoRatioSnapCarousel(store: self.store)
                                    .animation(.spring())
                                    .accessibilityElement(children: .ignore)
                                    .accessibility(label: Text("Ratio is 1 to \(viewStore.activeRatioDenominator)"))

                                RatioDenominatorLine()
                                    .frame(width: geo.size.width / 2 - .cafeo(.scale05))
                            }
                            .frame(width: geo.size.width / 2,
                                   height: geo.size.height)
                            .cafeoInnerShadow()

                            // Control the tappable area
                            .clipShape(Rectangle())
                            .contentShape(Rectangle())
                        }
                    }
                }
                .accessibility(sortPriority: 0)

                Button(action: {
                    self.showSavedPresets.toggle()
                }, label: {
                    Text("ratio: \(viewStore.selectedPreset?.name ?? "none")".localized)
                        .kerning(.cafeo(.standard))
                        .cafeoText(.mainLabel, color: .cafeoGray)
                        .textCase(.uppercase)
                        .accessibility(sortPriority: 1)
                })
                .sheet(isPresented: self.$showSavedPresets) {
                    CafeoSavedPresetsView(
                        store: self.store.scope(
                            state: \.savedPresetsState,
                            action: { .savedPresetsAction($0) }
                        ),
                        selectedPreset: viewStore.selectedPreset,
                        newPresetSelected: {
                            viewStore.send(.currentSettingsUpdated($0))
                        }
                    )
                }

                Button(action: {
                    self.showSavePresetAlert.toggle()
                }, label: {
                    ZStack {
                        EmptyView()
                            .cafeoAlert(isPresented: self.$showSavePresetAlert,
                                        .init(title: "Save Preset".localized,
                                              message: "Give your preset a name.".localized,
                                              placeholder: "e.g. Morning brew, Espresso...".localized,
                                              accept: "Save".localized,
                                              cancel: "Cancel".localized,
                                              action: { presetName in
                                                if let name = presetName {
                                                    viewStore.send(.savedPresetsAction(.savePreset(name, viewStore.currentSettings)))
                                                }
                                              }))
                            .frame(width: 0, height: 0, alignment: .center)
                        Image.cafeo(.plus)
                    }
                })
            }
            .accessibilityElement(children: .contain)
        }
    }
}

// MARK: - Helpers

extension CafeoRatioView {
    struct Divider: View {
        var body: some View {
            HStack {
                Spacer()
                Rectangle()
                    .frame(width: .cafeo(.scale05))
                    .foregroundColor(.cafeoShadowDark1)
                Spacer()
            }
        }
    }

    struct RatioDenominatorLine: View {
        var body: some View {
            ZStack {
                Rectangle()
                    .foregroundColor(.cafeoOrange)
                    .shadow(color: .black05, radius: 2, x: 0, y: 1)

                // highlight
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.white03)
                    .blur(radius: 1)
            }
            .frame(height: 2)
        }
    }

    private var ratioBox: RoundedRectangle {
        RoundedRectangle(cornerRadius: .cafeo(.scale2))
    }
}
