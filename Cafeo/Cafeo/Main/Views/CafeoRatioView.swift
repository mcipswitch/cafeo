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

    struct ViewState: Equatable {
        let settings: AppState.PresetSettings
        let selectedPreset: CafeoPresetDomain.State?
        let activeRatioDenominator: Int
        let showSavedPresetsView: Bool
        let showSavePresetAlert: Bool

        init(state: AppState) {
            self.settings = state.settings
            self.selectedPreset = state.selectedPreset
            self.activeRatioDenominator = state.ratioDenominators[self.settings.activeRatioIdx]
            self.showSavedPresetsView = state.showSavedPresetsView
            self.showSavePresetAlert = state.showSavePresetAlert
        }
    }

    var body: some View {
        WithViewStore(self.store.scope(state: ViewState.init)) { viewStore in
            VStack(spacing: .cafeo(.spacing20)) {
                ZStack {
                    GeometryReader { geo in
                        self.ratioBox
                            .stroke(Color.cafeoShadowLight, lineWidth: 2)
                            .background(self.ratioBox.fill(LinearGradient.cafeoChrome))

                        Divider()

                        HStack(spacing: 0) {
                            Text("1")
                                .cafeoText(.ratioLabel, color: .cafeoBeige)
                                .frame(
                                    width: geo.size.width / 2,
                                    height: geo.size.height
                                )
                                .cafeoInnerShadow()

                            ZStack {
                                CafeoRatioSnapCarousel(
                                    store: self.store,
                                    height: geo.size.height
                                )
                                    .animation(.spring())
                                    .accessibilityElement(children: .ignore)
                                    .accessibility(label: Text("Ratio is 1 to \(viewStore.activeRatioDenominator)"))

                                RatioDenominatorLine()
                                    .frame(width: geo.size.width / 2 - .cafeo(.spacing2))
                            }
                            .frame(
                                width: geo.size.width / 2,
                                height: geo.size.height - .cafeo(.spacing4)
                            )
                            .cafeoInnerShadow()

                            // Control the tappable area
                            .clipShape(Rectangle())
                            .contentShape(Rectangle())
                        }
                    }
                }
                .accessibility(sortPriority: 0)


                VStack(spacing: .cafeo(.spacing2)) {

                    // MARK: Ratio Button
                    Button {
                        viewStore.send(.showSavedPresetsView(true))
                    } label: {
                        Text(viewStore.selectedPreset?.name ?? "Custom".localized)
                            .kerning(.cafeo(.standard))
                            .cafeoText(.mainLabel, color: .cafeoGray)
                            .textCase(.uppercase)
                    }.accessibility(sortPriority: 1)
                        .sheet(
                            isPresented: viewStore.binding(
                                get: \.showSavedPresetsView,
                                send: .none
                            ),
                            onDismiss: {
                                viewStore.send(.showSavedPresetsView(false))
                            }) {
                                CafeoSavedPresetsView(
                                    store: self.store.scope(
                                        state: \.savedPresetsState,
                                        action: { .savedPresetsAction($0) }
                                    ),
                                    selectedPreset: viewStore.selectedPreset
                                )
                            }

                    // MARK: Save Button
                    Button {
                        viewStore.send(.toggleSavePresetAlert)
                    } label: {
                        ZStack {
                            EmptyView()
                                .cafeoAlert(
                                    isPresented: viewStore.binding(
                                        get: \.showSavePresetAlert,
                                        send: .toggleSavePresetAlert
                                    ),
                                    CafeoTextAlert(
                                        title: "Save Preset".localized,
                                        message: "Give your preset a name.".localized,
                                        placeholder: "e.g. Morning brew, Espresso...".localized,
                                        accept: "Save".localized,
                                        cancel: "Cancel".localized,
                                        action: { presetName in
                                            if let name = presetName, !name.isEmpty {
                                                let preset = CafeoPresetDomain.State(name: name, settings: viewStore.settings)
                                                viewStore.send(.savedPresetsAction(.savePreset(preset)))
                                            }
                                        }
                                    )
                                )
                                .frame(width: 0, height: 0, alignment: .center)

                            Text("Save New Preset".localized)
                                .kerning(.cafeo(.standard))
                                .cafeoText(.miniLabel, color: .cafeoOrange)
                                .textCase(.uppercase)
                        }
                    }
                }
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
                    .frame(width: .cafeo(.spacing2))
                    .foregroundColor(.cafeoShadowLight)
                Spacer()
            }
        }
    }

    struct RatioDenominatorLine: View {
        var body: some View {
            ZStack {
                Rectangle()
                    .foregroundColor(.cafeoOrange)
                    .shadow(color: .cafeoBlack05, radius: 2, x: 0, y: 1)

                // highlight
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.cafeoWhite03)
                    .blur(radius: 1)
            }
            .frame(height: 2)
        }
    }

    private var ratioBox: RoundedRectangle {
        RoundedRectangle(cornerRadius: .cafeo(.spacing8))
    }
}
