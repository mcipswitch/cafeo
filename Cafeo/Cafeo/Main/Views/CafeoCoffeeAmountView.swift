//
//  CafeoCoffeeAmountView.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-13.
//

import ComposableArchitecture
import SwiftUI

struct CafeoCoffeeAmountView: View {
    let store: Store<AppState, AppAction>
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>

    init(store: Store<AppState, AppAction>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(spacing: 20) {
                Text(CafeoIngredient.coffee.rawValue.localized)
                    .kerning(.cafeo(.standard))
                    .cafeoText(.mainLabel, color: .cafeoGray)
                    .textCase(.uppercase)

                VStack(spacing: 10) {
                    Text(viewStore.coffeeAmount.format(to: "%.1f"))
                        .kerning(.cafeo(.large))
                        .cafeoText(.digitalLabel, color: .cafeoBeige)
                        .accessibility(value: Text("\(viewStore.unitConversion.rawValue)"))
                    CafeoIngredientQuantityButton(
                        onPress: self.onPress(_:),
                        onRelease: self.onRelease,
                        onTap: self.onTap(_:)
                    )
                }

                Toggle(isOn: viewStore.binding(
                    get: \.coffeeAmountIsLocked,
                    send: AppAction.amountLockToggled
                ), label: {
                    Text("Coffee Amount")
                })
                .toggleStyle(CafeoLockToggleStyle())
                .labelsHidden()
                .padding(.top, 20)
                .accessibility(label: Text("Coffee Amount"))
            }
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
