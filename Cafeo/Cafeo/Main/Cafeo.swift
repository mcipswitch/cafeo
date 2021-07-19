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
            BackgroundPattern()
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                Spacer()

                CafeoRatioView(store: self.store)
                    .frame(height: 180)
                    .padding(.horizontal, .cafeo(.scale5))
                    .padding(.vertical, .cafeo(.scale55))
                    .background(Color.cafeoBackgroundDark)

                CafeoIngredientAmountView(store: self.store)
                    .padding(.vertical, .cafeo(.scale55))
                    .background(Color.cafeoBackgroundLight)
                    .accessibilityElement(children: .contain)

                CafeoUnitConversionView(store: self.store)
                    .padding(.horizontal, .cafeo(.scale5))
                    .padding(.vertical, .cafeo(.scale55))
                    .background(Color.cafeoBackgroundDark)
            }
        }
        .background(Color.cafeoBackgroundDark)
    }
}

extension Cafeo {
    private struct BackgroundPattern: View {
        var body: some View {
            VStack(spacing: 0) {
                Image(decorative: "background-pattern")
                    .resizable(resizingMode: .tile)
                Color.cafeoBackgroundDark
            }
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
