//
//  CafeoCoffeeAmountView.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-13.
//

import ComposableArchitecture
import SwiftUI

struct CafeoCoffeeAmountDomain {
    struct State: Equatable {
        var amount: Double
        var isLocked: Bool
        var quantityStepperState: CafeoIngredientQuantityButtonDomain.State = .init()
    }

    enum Action: Equatable {
        case lockAmount
        case quantityStepperAction(CafeoIngredientQuantityButtonDomain.Action)
    }

    struct Environment {}

    static let reducer: Reducer<State, Action, Environment> = {
        return .combine(
            CafeoIngredientQuantityButtonDomain.reducer.pullback(
                state: \CafeoCoffeeAmountDomain.State.quantityStepperState,
                action: /CafeoCoffeeAmountDomain.Action.quantityStepperAction,
                environment: { _ in .init() }
            ),
            Reducer.init { _, _, _ in
                return .none
            }
        )
    }()
}

struct CafeoCoffeeAmountView: View {
    let store: Store<CafeoCoffeeAmountDomain.State, CafeoCoffeeAmountDomain.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(spacing: CommonConstants.Spacing.spacing16) {
                Text(CommonStrings.coffee.localizedUppercase)
                    .kerning(CommonConstants.Kerning.standard)
                    .cafeoText(.mainLabel, color: CommonAssets.Colors.cafeoGray)

                VStack(spacing: CommonConstants.Spacing.spacing10) {
                    Text(String(format: "%.1f", viewStore.amount))
                        .kerning(CommonConstants.Kerning.large)
                        .cafeoText(.digitalLabel, color: CommonAssets.Colors.cafeoBeige)

                    CafeoIngredientQuantityButton(
                        store: self.store.scope(
                            state: \.quantityStepperState,
                            action: { .quantityStepperAction($0) }
                        )
                    )
                }

                Toggle(isOn: viewStore.binding(
                    get: \.isLocked,
                    send: .lockAmount
                ), label: {
                    Text("Coffee Amount Lock")
                })
                .toggleStyle(CafeoLockToggleStyle())
                .labelsHidden()
                .padding(.top, CommonConstants.Spacing.spacing20)
                .accessibility(label: Text("Coffee Amount"))
            }
        }
    }
}
