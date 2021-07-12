//
//  CafeoCoffeeAmountView.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-13.
//

import ComposableArchitecture
import SwiftUI

struct CafeoCoffeeAmountView: View {
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>

    var body: some View {
        VStack(spacing: 20) {
            CafeoText(text: CafeoIngredient.coffee.rawValue.localized, .mainLabel)

            VStack(spacing: 10) {
                CafeoText(text: self.viewStore.coffeeAmount.format(to: "%.1f"), .digitalLabel)
                    .accessibility(value: Text("\(self.viewStore.unitConversion.rawValue)"))

                IngredientAdjustButton(
                    onPress: self.onPress(_:),
                    onRelease: self.onRelease,
                    onTap: self.onTap(_:)
                )
            }
            Toggle(isOn: self.viewStore.binding(
                get: \.coffeeAmountIsLocked,
                send: AppAction.amountLockToggled
            ), label: {
                Text("Coffee Amount")
            })
            .toggleStyle(LockToggleStyle())
            .labelsHidden()
            .padding(.top, 20)
            .accessibility(label: Text("Coffee Amount"))
        }
    }
}

// MARK: - Helpers

extension CafeoCoffeeAmountView {
    private func onPress(_ action: IngredientAction) {
        self.viewStore.send(.adjustAmountButtonLongPressed(.coffee, action))
    }

    private func onRelease() {
        self.viewStore.send(.form(.set(\.isLongPressing, false)))
    }

    private func onTap(_ action: IngredientAction) {
        self.viewStore.send(.coffeeAmountChanged(action))
    }
}
