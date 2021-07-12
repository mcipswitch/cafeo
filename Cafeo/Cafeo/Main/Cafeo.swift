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
    var padding: CGFloat = 30

    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {

                // Background
                VStack(spacing: 0) {
                    Image(decorative: "background-pattern")
                        .resizable(resizingMode: .tile)
                    Color.cafeoBackgroundDark
                }
                .edgesIgnoringSafeArea(.all)

                VStack(spacing: 0) {
                    Spacer()

                    CafeoRatioView(viewStore: viewStore)
                        .frame(height: 180)
                        .padding(.horizontal, 24)
                        .padding(.vertical, self.padding)
                        .background(Color.cafeoBackgroundDark)

                    CafeoIngredientAmountView(viewStore: viewStore)
                        .padding(.vertical, self.padding)
                        .background(Color.cafeoBackgroundLight)
                        .accessibilityElement(children: .contain)

                    CafeoUnitConversionView(viewStore: viewStore)
                        .padding(.horizontal, 24)
                        .padding(.vertical, self.padding)
                        .background(Color.cafeoBackgroundDark)
                }
            }
            .background(Color.cafeoBackgroundDark)
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
