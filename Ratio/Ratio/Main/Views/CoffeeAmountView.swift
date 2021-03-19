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

    var body: some View {
        VStack(spacing: 20) {
            CoffioText(text: CoffioIngredient.coffee.rawValue, .mainLabel)

            VStack(spacing: 10) {
                CoffioText(text: viewStore.coffeeAmount.format(to: "%.1f"), .digitalLabel)

                AmountAdjustButton(
                    onPress: self.onPress(_:),
                    onRelease: self.onRelease,
                    onTap: self.onTap(_:)
                )
            }

            Toggle("", isOn: viewStore.binding(
                    get: \.coffeeAmountIsLocked,
                    send: AppAction.amountLockToggled
            )).toggleStyle(LockToggleStyle())
            .padding(.top, 20)
        }
    }
}

extension CoffeeAmountView {
    private func onPress(_ action: AmountAction) {
        self.viewStore.send(.adjustAmountButtonLongPressed(.coffee, action))
    }

    private func onRelease() {
        self.viewStore.send(.form(.set(\.isLongPressing, false)))
    }

    private func onTap(_ action: AmountAction) {
        self.viewStore.send(.coffeeAmountChanged(action))
    }
}
