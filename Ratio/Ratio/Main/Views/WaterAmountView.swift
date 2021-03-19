//
//  WaterAmountView.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-03-13.
//

import ComposableArchitecture
import SwiftUI

struct WaterAmountView: View {
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>

    var body: some View {
        VStack(spacing: 20) {
            CoffioText(text: CoffioIngredient.water.rawValue, .mainLabel)
            VStack(spacing: 10) {
                CoffioText(text: viewStore.waterAmount.format(to: "%.0f"), .digitalLabel)

                AmountAdjustButton(
                    onPress: self.onPress(_:),
                    onRelease: self.onRelease,
                    onTap: self.onTap(_:)
                )
            }
            Toggle("", isOn: viewStore.binding(
                    get: \.waterAmountIsLocked,
                    send: .amountLockToggled)
            ).toggleStyle(LockToggleStyle())
            .padding(.top, 20)
        }
    }
}

// MARK: - WaterAmountView+Extension

extension WaterAmountView {
    private func onPress(_ action: AmountAction) {
        self.viewStore.send(.adjustAmountButtonLongPressed(.water, action))
    }

    private func onRelease() {
        self.viewStore.send(.form(.set(\.isLongPressing, false)))
    }

    private func onTap(_ action: AmountAction) {
        self.viewStore.send(.waterAmountChanged(action))
    }
}
