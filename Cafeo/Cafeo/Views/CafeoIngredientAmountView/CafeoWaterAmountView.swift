//
//  CafeoWaterAmountView.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-13.
//

import ComposableArchitecture
import SwiftUI

struct CafeoWaterAmountDomain {
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
                state: \CafeoWaterAmountDomain.State.quantityStepperState,
                action: /CafeoWaterAmountDomain.Action.quantityStepperAction,
                environment: { _ in .init() }
            ),
            Reducer.init { _, _, _ in
                return .none
            }
        )
    }()
}

struct CafeoWaterAmountView: View {
    let store: Store<CafeoWaterAmountDomain.State, CafeoWaterAmountDomain.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(spacing: CommonConstants.Spacing.spacing16) {
                Text(CommonStrings.water.localizedUppercase)
                    .kerning(CommonConstants.Kerning.standard)
                    .cafeoText(.mainLabel, color: CommonAssets.Colors.cafeoGray)

                VStack(spacing: CommonConstants.Spacing.spacing10) {
                    Text(String(format: "%.0f", viewStore.amount))
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
                    Text("Water Amount Lock")
                })
                .toggleStyle(CafeoLockToggleStyle())
                .labelsHidden()
                .padding(.top, CommonConstants.Spacing.spacing20)
                .accessibility(label: Text("Water Amount"))
            }
        }
    }
}
