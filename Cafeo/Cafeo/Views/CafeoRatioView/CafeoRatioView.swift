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
        let activeRatioDenominator: Int

        init(state: AppState) {
            self.settings = state.settings
            self.activeRatioDenominator = state.ratioDenominators[self.settings.activeRatioIdx]
        }
    }

    var body: some View {
        WithViewStore(self.store.scope(state: ViewState.init)) { viewStore in
            VStack(spacing: CommonConstants.Spacing.spacing20) {
                ZStack {
                    GeometryReader { geo in
                        self.ratioBox
                            .stroke(CommonAssets.Colors.cafeoShadowLight, lineWidth: 2)
                            .background(self.ratioBox.fill(CommonAssets.Gradients.cafeoChrome))

                        Divider()

                        HStack(spacing: 0) {
                            Text("1")
                                .cafeoText(.ratioLabel, color: CommonAssets.Colors.cafeoBeige)
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
                                    .frame(width: geo.size.width / 2 - CommonConstants.Spacing.spacing2)
                            }
                            .frame(
                                width: geo.size.width / 2,
                                height: geo.size.height - CommonConstants.Spacing.spacing4
                            )
                            .cafeoInnerShadow()

                            // Control the tappable area
                            .clipShape(Rectangle())
                            .contentShape(Rectangle())
                        }
                    }
                }
                .accessibility(sortPriority: 0)
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
                    .frame(width: CommonConstants.Spacing.spacing2)
                    .foregroundColor(CommonAssets.Colors.cafeoShadowLight)
                Spacer()
            }
        }
    }

    struct RatioDenominatorLine: View {
        var body: some View {
            ZStack {
                Rectangle()
                    .foregroundColor(CommonAssets.Colors.cafeoOrange)
                    .shadow(color: CommonAssets.Colors.cafeoBlack05, radius: 2, x: 0, y: 1)

                // highlight
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(CommonAssets.Colors.cafeoWhite03)
                    .blur(radius: 1)
            }
            .frame(height: 2)
        }
    }

    private var ratioBox: RoundedRectangle {
        RoundedRectangle(cornerRadius: CommonConstants.Spacing.spacing8)
    }
}
