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

    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                VStack(spacing: 0) {
                    Image("top-image")
                        .resizable()
                        .scaledToFit()
                    Image("top-image")
                        .resizable()
                        .scaledToFit()
                    Spacer()
                }

                VStack(spacing: 0) {
                    Spacer()

                    RatioView(viewStore: viewStore)
                        .frame(height: 180)
                        .padding(.horizontal, 24)
                        .padding(.top, 40)
                        .padding(.bottom, 40)
                        .background(Color.coffioBackgroundDark)

                    HStack {
                        CoffeeAmountView(viewStore: viewStore)
                            .frame(width: UIScreen.main.bounds.width / 2)
                        WaterAmountView(viewStore: viewStore)
                            .frame(width: UIScreen.main.bounds.width / 2)
                    }
                    .padding(.vertical, 30)
                    .background(Color.coffioBackgroundLight)

                    UnitConversionView(viewStore: viewStore)
                        .padding(.horizontal, 24)
                        .padding(.top, 40)
                        .padding(.bottom, 40)
                        .background(Color.coffioBackgroundDark)
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

// MARK: - Previews

struct Coffio_Previews: PreviewProvider {
    static var previews: some View {
        Coffio(store: Store(initialState: AppState(),
                            reducer: appReducer,
                            environment: AppEnvironment()
        ))
    }
}
