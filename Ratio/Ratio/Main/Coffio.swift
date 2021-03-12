//
//  Coffio.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-03-08.
//

import ComposableArchitecture
import SwiftUI

struct WaterAmountView: View {
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>

    private func onPress(_ action: AmountAction) {
        self.viewStore.send(.amountButtonLongPressed(.water, action))
    }

    private func onRelease() {
        self.viewStore.send(.form(.set(\.isLongPressing, false)))
    }

    private func onTap(_ action: AmountAction) {
        self.viewStore.send(.waterAmountChanged(action))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            CoffioText(text: "water", .mainLabel)
            
            VStack(spacing: 10) {
                // TODO: - How to use CoffioText with specifier?
                Text("\(viewStore.waterAmount, specifier: "%.0f")")
                    .kerning(4)
                    .coffioTextStyle(.digitalLabel)
                
                IncrementDecrementButton(
                    onPress: self.onPress(_:),
                    onRelease: self.onRelease,
                    onTap: self.onTap(_:)
                )
            }
            
            Toggle("", isOn: viewStore.binding(
                keyPath: \.lockWaterAmount,
                send: AppAction.form
            )).toggleStyle(LockToggleStyle())
            .padding(.top, 20)
        }
    }
}

struct CoffeeAmountView: View {
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>

    private func onPress(_ action: AmountAction) {
        self.viewStore.send(.amountButtonLongPressed(.coffee, action))
    }

    private func onRelease() {
        self.viewStore.send(.form(.set(\.isLongPressing, false)))
    }
    
    private func onTap(_ action: AmountAction) {
        self.viewStore.send(.coffeeAmountChanged(action))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            CoffioText(text: "coffee", .mainLabel)
            
            VStack(spacing: 10) {
                Text("\(viewStore.coffeeAmount, specifier: "%.1f")")
                    .kerning(4)
                    .coffioTextStyle(.digitalLabel)
                
                IncrementDecrementButton(
                    onPress: self.onPress(_:),
                    onRelease: self.onRelease,
                    onTap: self.onTap(_:)
                )
            }
            
            Toggle("", isOn: viewStore.binding(
                keyPath: \.lockCoffeeAmount,
                send: AppAction.form
            )).toggleStyle(LockToggleStyle())
            .padding(.top, 20)
        }
    }
}

// MARK: - Coffio

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



struct SizePrefKey: PreferenceKey {
    static var defaultValue: Anchor<CGRect>? = nil
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = nextValue()
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
