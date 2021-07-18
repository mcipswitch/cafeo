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
                    Text(viewStore.currentSettings.waterAmount.format(to: "%.0f"))
                        .kerning(.cafeo(.large))
                        .cafeoText(.digitalLabel, color: .cafeoBeige)
                        .accessibility(value: Text("\(viewStore.currentSettings.unitConversion.rawValue)"))
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { self.onWaterQuantityLabelDrag($0) }
                                .onEnded { _ in self.onRelease() }
                        )

                    CafeoIngredientQuantityButton(
                        onPress: self.onPress(_:),
                        onRelease: self.onRelease,
                        onTap: self.onTap(_:)
                    )
                }

                Toggle(isOn: viewStore.binding(
                    get: \.currentSettings.waterAmountIsLocked,
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
        self.viewStore.send(.quantityButtonLongPressed(.water, action))
    }

    private func onRelease() {
        self.viewStore.send(.onRelease)
    }

    private func onTap(_ action: IngredientAction) {
        self.viewStore.send(.waterAmountChanged(action))
    }

    private func onWaterQuantityLabelDrag(_ value: DragGesture.Value) {
        if value.translation.width > 0 {
            self.viewStore.send(.quantityLabelDragged(.water, .increment))
        } else if value.translation.width < 0 {
            self.viewStore.send(.quantityLabelDragged(.water, .decrement))
        }
    }
}
