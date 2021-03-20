//
//  Coffio.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-03-08.
//

import ComposableArchitecture
import SwiftUI

struct Coffio: View {
    let store: Store<AppState, AppAction>
    var padding: CGFloat = 30

    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                VStack(spacing: 0) {
                    // TODO: - fix background
                    Image(decorative: "top-image")
                        .resizable()
                        .scaledToFit()
                    Image(decorative: "top-image")
                        .resizable()
                        .scaledToFit()
                    Color.coffioBackgroundDark
                }
                .edgesIgnoringSafeArea(.all)

                VStack(spacing: 0) {
                    Spacer()

                    RatioView(viewStore: viewStore)
                        .frame(height: 180)
                        .padding(.horizontal, 24)
                        .padding(.vertical, self.padding)
                        .background(Color.coffioBackgroundDark)

                    HStack {
                        CoffeeAmountView(viewStore: viewStore)
                            .frame(width: UIScreen.main.bounds.width / 2)
                            .accessibility(sortPriority: 1)
                        WaterAmountView(viewStore: viewStore)
                            .frame(width: UIScreen.main.bounds.width / 2)
                            .accessibility(sortPriority: 0)
                    }
                    .padding(.vertical, self.padding)
                    .background(Color.coffioBackgroundLight)
                    .accessibilityElement(children: .contain)

                    UnitConversionView(viewStore: viewStore)
                        .padding(.horizontal, 24)
                        .padding(.vertical, self.padding)
                        .background(Color.coffioBackgroundDark)
                }
            }
            .background(Color.coffioBackgroundDark)
        }
    }
}

// MARK: - Previews

struct Coffio_Previews: PreviewProvider {
    static var previews: some View {
        Coffio(store: Store(initialState: AppState(),
                            reducer: appReducer,
                            environment: AppEnvironment(
                                mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                            )
        ))

        Coffio(store: Store(initialState: AppState(),
                            reducer: appReducer,
                            environment: AppEnvironment(
                                mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                            )
        )).environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }
}
