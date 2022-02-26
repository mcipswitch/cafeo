//
//  CafeoMainView.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-08.
//

import ComposableArchitecture
import SwiftUI

struct CafeoMainView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Image(decorative: CommonAssets.Images.backgroundPattern)
                    .resizable(resizingMode: .tile)
                CommonAssets.Colors.cafeoPrimaryBackgroundDark
            }
            .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                Spacer()
                CafeoRatioView(store: self.store)
                    .frame(minHeight: 150, maxHeight: 180)
                    .padding(.horizontal, CommonConstants.Spacing.spacing24)
                    .padding(.vertical, CommonConstants.Spacing.spacing24)
                    .background(CommonAssets.Colors.cafeoPrimaryBackgroundDark)
                CafeoIngredientAmountView(store: self.store)
                    .padding(.vertical, CommonConstants.Spacing.spacing24)
                    .background(CommonAssets.Colors.cafeoPrimaryBackgroundLight)
                    .accessibilityElement(children: .contain)
                CafeoUnitConversionView(store: self.store)
                    .padding(.horizontal, CommonConstants.Spacing.spacing24)
                    .padding(.top, CommonConstants.Spacing.spacing24)
                    .background(CommonAssets.Colors.cafeoPrimaryBackgroundDark)
            }
            .padding(.vertical, CommonConstants.Spacing.spacing20)
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

// MARK: - Previews

struct Cafeo_Previews: PreviewProvider {
    static var previews: some View {
        CafeoMainView(
            store: Store(
                initialState: AppState(),
                reducer: appReducer,
                environment: AppEnvironment(
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                )
            )
        )
        CafeoMainView(
            store: Store(
                initialState: AppState(),
                reducer: appReducer,
                environment: AppEnvironment(
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                )
            )
        )
        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
        .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
    }
}
