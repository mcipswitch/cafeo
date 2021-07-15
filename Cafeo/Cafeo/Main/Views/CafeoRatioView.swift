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
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>

    init(store: Store<AppState, AppAction>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(spacing: 20) {
                ZStack {
                    GeometryReader { geo in
                        self.ratioBox
                            .stroke(Color.cafeoShadowDark1, lineWidth: 2)
                            .background(self.ratioBox.fill(LinearGradient.cafeoChrome))

                        self.divider

                        HStack(spacing: 0) {
                            Text("1")
                                .kerning(.cafeo(.large))
                                .cafeoText(.ratioLabel, color: .cafeoBeige)
                                .frame(
                                    width: geo.size.width / 2,
                                    height: geo.size.height
                                )
                                .addInnerShadow()
                            ZStack {
                                CafeoRatioSnapCarousel(store: self.store)
                                    .animation(.spring())
                                    .accessibilityElement(children: .ignore)
                                    .accessibility(label: Text("Ratio is 1 to \(viewStore.activeRatioDenominator)"))

                                self.ratioDenominatorLine
                                    .frame(width: geo.size.width / 2 - .cafeo(.scale05))
                            }
                            .frame(
                                width: geo.size.width / 2,
                                height: geo.size.height
                            )
                            .addInnerShadow()

                            // Control the tappable area
                            .clipShape(Rectangle())
                            .contentShape(Rectangle())
                        }
                    }
                }
                .accessibility(sortPriority: 0)

                Text("ratio".localized)
                    .kerning(.cafeo(.standard))
                    .cafeoText(.mainLabel, color: .cafeoGray)
                    .textCase(.uppercase)
                    .accessibility(sortPriority: 1)
            }
            .accessibilityElement(children: .contain)
        }
    }

    // MARK: Helpers

    private var divider: some View {
        HStack {
            Spacer()
            Rectangle().frame(width: .cafeo(.scale05))
                .foregroundColor(.cafeoShadowDark1)
            Spacer()
        }
    }

    private var ratioBox: RoundedRectangle {
        RoundedRectangle(cornerRadius: .cafeo(.scale2
        ))
    }

    private var ratioDenominatorLine: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.cafeoOrange)
                .shadow(color: .black05, radius: 2, x: 0, y: 1)

            // highlight
            Rectangle().frame(height: 1)
                .foregroundColor(.white03)
                .blur(radius: 1)
        }
        .frame(height: 2)
    }
}
