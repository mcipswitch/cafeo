//
//  CafeoWaterAmountView.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-13.
//

import ComposableArchitecture
import SwiftUI

struct CafeoWaterAmountView: View {
    let store: Store<AppState, AppAction>
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>

    init(store: Store<AppState, AppAction>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(spacing: 20) {
                Text(CafeoIngredient.water.rawValue.localized)
                    .kerning(.cafeo(.standard))
                    .cafeoText(.mainLabel, color: .cafeoGray)
                    .textCase(.uppercase)

                VStack(spacing: .cafeo(.scale25)) {
                    Text(viewStore.waterAmount.format(to: "%.0f"))
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
                    get: \.waterAmountIsLocked,
                    send: .amountLockToggled
                ), label: {
                    Text("Water Amount Lock")
                })
                .toggleStyle(CafeoLockToggleStyle())
                .labelsHidden()
                .padding(.top, .cafeo(.scale45))
                .accessibility(label: Text("Water Amount"))
            }
        }
    }
}

// MARK: - Helpers

extension CafeoWaterAmountView {
    private func onPress(_ action: IngredientAction) {
        self.viewStore.send(.adjustAmountButtonLongPressed(.water, action))
    }

    private func onRelease() {
        self.viewStore.send(.form(.set(\.isLongPressing, false)))
    }

    private func onTap(_ action: IngredientAction) {
        self.viewStore.send(.waterAmountChanged(action))
    }
}
