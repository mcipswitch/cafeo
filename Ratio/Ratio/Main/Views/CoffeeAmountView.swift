//
//  CoffeeAmountView.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-03-13.
//

import ComposableArchitecture
import SwiftUI

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
