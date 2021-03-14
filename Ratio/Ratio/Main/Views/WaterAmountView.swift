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
            CoffioText(text: "water", .mainLabel)
            VStack(spacing: 10) {
                CoffioText(text: viewStore.waterAmount.format(to: "%.0f"), .digitalLabel)

                IncrementDecrementButton(
                    onPress: self.onPress(_:),
                    onRelease: self.onRelease,
                    onTap: self.onTap(_:)
                )
            }
            Toggle("", isOn: viewStore.binding(
                keyPath: \.waterAmountIsLocked,
                send: AppAction.form
            )).toggleStyle(LockToggleStyle())
            .padding(.top, 20)
        }
    }
}

// MARK: - WaterAmountView+Extension

extension WaterAmountView {
    private func onPress(_ action: AdjustAmountAction) {
        self.viewStore.send(.adjustAmountButtonLongPressed(.water, action))
    }

    private func onRelease() {
        self.viewStore.send(.form(.set(\.isLongPressing, false)))
    }

    private func onTap(_ action: AdjustAmountAction) {
        self.viewStore.send(.waterAmountChanged(action))
    }
}
