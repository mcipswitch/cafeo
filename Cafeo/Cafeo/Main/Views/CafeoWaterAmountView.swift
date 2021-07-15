//
//  CafeoWaterAmountView.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-13.
//

import ComposableArchitecture
import SwiftUI

struct CafeoWaterAmountView: View {
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>

    var body: some View {
        VStack(spacing: 20) {
            Text(CafeoIngredient.water.rawValue.localized)
                .kerning(1.5)
                .cafeoText(.mainLabel, color: .cafeoGray)
                .textCase(.uppercase)
            
            VStack(spacing: 10) {
                Text(self.viewStore.waterAmount.format(to: "%.0f"))
                    .kerning(4.0)
                    .cafeoText(.digitalLabel, color: .cafeoBeige)
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
            .toggleStyle(CafeoLockToggleStyle())
            .labelsHidden()
            .padding(.top, 20)
            .accessibility(label: Text("Water Amount"))
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
