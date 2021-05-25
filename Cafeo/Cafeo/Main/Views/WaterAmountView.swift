//
//  WaterAmountView.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-13.
//

import ComposableArchitecture
import SwiftUI

struct WaterAmountView: View {
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>

    var body: some View {
        VStack(spacing: 20) {
            CafeoText(text: CafeoIngredient.water.rawValue.localized, .mainLabel)
            
            VStack(spacing: 10) {
                CafeoText(text: self.viewStore.waterAmount.format(to: "%.0f"), .digitalLabel)
                    .accessibility(value: Text("\(self.viewStore.unitConversion.rawValue)"))

                IngredientAdjustButton(
                    onPress: self.onPress(_:),
                    onRelease: self.onRelease,
                    onTap: self.onTap(_:)
                )
            }
            Toggle(isOn: self.viewStore.binding(
                get: \.waterAmountIsLocked,
                send: .amountLockToggled
            ), label: {
                Text("Water Amount Lock")
            })
            .toggleStyle(LockToggleStyle())
            .labelsHidden()
            .padding(.top, 20)
            .accessibility(label: Text("Water Amount"))
        }
    }
}

// MARK: - Helpers

extension WaterAmountView {
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
