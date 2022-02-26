//
//  CafeoIngredientAmountView.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-04-15.
//

import ComposableArchitecture
import SwiftUI

struct CafeoIngredientAmountView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack {
                CafeoCoffeeAmountView(
                    store: self.store.scope(
                        state: {
                            .init(
                                amount: $0.settings.coffeeAmount,
                                isLocked: $0.settings.lockedIngredient == .coffee
                            )
                        },
                        action: { .coffeeAction($0) }
                    )
                )
                // TODO: Change to GeometryReader
                .frame(width: UIScreen.main.bounds.width / 2)
                .accessibility(sortPriority: 1)

                CafeoWaterAmountView(
                    store: self.store.scope(
                        state: {
                            .init(
                                amount: $0.settings.waterAmount,
                                isLocked: $0.settings.lockedIngredient == .water
                            )
                        },
                        action: { .waterAction($0) }
                    )
                )
                // TODO: Change to GeometryReader
                .frame(width: UIScreen.main.bounds.width / 2)
                .accessibility(sortPriority: 0)
            }
        }
    }
}
