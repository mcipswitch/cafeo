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
