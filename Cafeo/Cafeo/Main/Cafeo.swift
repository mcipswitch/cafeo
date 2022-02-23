//
//  Cafeo.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-08.
//

import ComposableArchitecture
import SwiftUI

struct Cafeo: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        ZStack {

            // MARK: Background Pattern
            self.backgroundPattern.edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                Spacer()

                // MARK: Ratio Carousel
                CafeoRatioView(store: self.store)
                    .frame(minHeight: 150, maxHeight: 180)
                    .padding(.horizontal, .cafeo(.spacing24))
                    .padding(.vertical, .cafeo(.spacing24))
                    .background(Color.primaryBackgroundDark)

                // MARK: Ingredients
                CafeoIngredientAmountView(store: self.store)
                    .padding(.vertical, .cafeo(.spacing24))
                    .background(Color.primaryBackgroundLight)
                    .accessibilityElement(children: .contain)

                // MARK: Conversion Toggle
                CafeoUnitConversionView(store: self.store)
                    .padding(.horizontal, .cafeo(.spacing24))
                    .padding(.top, .cafeo(.spacing24))
                    .background(Color.primaryBackgroundDark)
            }
            .padding(.vertical, .cafeo(.spacing20))
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

extension Cafeo {
    private var backgroundPattern: some View {
        VStack(spacing: 0) {
            Image(decorative: "background-pattern")
                .resizable(resizingMode: .tile)
            Color.primaryBackgroundDark
        }
    }
}

// MARK: - Previews

struct Cafeo_Previews: PreviewProvider {
    static var previews: some View {
        Cafeo(store: Store(initialState: AppState(),
                           reducer: appReducer,
                           environment: AppEnvironment(
                            mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                           )
        ))

        Cafeo(store: Store(initialState: AppState(),
                           reducer: appReducer,
                           environment: AppEnvironment(
                            mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                           )
        ))
        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
        .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
    }
}
