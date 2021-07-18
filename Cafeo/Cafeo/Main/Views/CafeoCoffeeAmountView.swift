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
            VStack(spacing: .cafeo(.scale45)) {
                Text(CafeoIngredient.coffee.rawValue.localized)
                    .kerning(.cafeo(.standard))
                    .cafeoText(.mainLabel, color: .cafeoGray)
                    .textCase(.uppercase)

                VStack(spacing: .cafeo(.scale25)) {
                    Text(viewStore.currentSettings.coffeeAmount.format(to: "%.1f"))
                        .kerning(.cafeo(.large))
                        .cafeoText(.digitalLabel, color: .cafeoBeige)
                        .accessibility(value: Text("\(viewStore.currentSettings.unitConversion.rawValue)"))
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { self.onCoffeeQuantityLabelDrag($0) }
                                .onEnded { _ in self.onRelease() }
                        )

                    CafeoIngredientQuantityButton(
                        onPress: self.onPress(_:),
                        onRelease: self.onRelease,
                        onTap: self.onTap(_:)
                    )
                }

                Toggle(isOn: viewStore.binding(
                    get: \.currentSettings.coffeeAmountIsLocked,
                    send: AppAction.amountLockToggled
                ), label: {
                    Text("Coffee Amount")
                })
                .toggleStyle(CafeoLockToggleStyle())
                .labelsHidden()
                .padding(.top, .cafeo(.scale45))
                .accessibility(label: Text("Coffee Amount"))
            }
        }
    }
}

// MARK: - Helpers

extension CafeoCoffeeAmountView {
    private func onPress(_ action: IngredientAction) {
        self.viewStore.send(.quantityButtonLongPressed(.coffee, action))
    }

    private func onRelease() {
        self.viewStore.send(.onRelease)
    }

    private func onTap(_ action: IngredientAction) {
        self.viewStore.send(.coffeeAmountChanged(action))
    }

    private func onCoffeeQuantityLabelDrag(_ value: DragGesture.Value) {

        let dragDistance = value.translation.width

        if dragDistance > 0 {
            self.viewStore.send(.quantityLabelDragged(.coffee, .increment))
        } else if dragDistance < 0 {
            self.viewStore.send(.quantityLabelDragged(.coffee, .decrement))
        }
    }
}
