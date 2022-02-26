//
//  CafeoCoffeeAmountView.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-13.
//

import ComposableArchitecture
import SwiftUI

// MARK: - CafeoCoffeeAmountDomain

struct CafeoCoffeeAmountDomain {

    struct State: Equatable {
        var amount: Double
        var isLocked: Bool

        var quantityStepperState: CafeoIngredientQuantityButtonDomain.State = .init()

        static var mock: Self {
            .init(
                amount: 15.625,
                isLocked: false,
                quantityStepperState: .init()
            )
        }
    }

    enum Action: Equatable {
        case lockAmount
        case amountDragged(IngredientAction)
        case onDragRelease

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

            Reducer.init { state, action, env in
                switch action {
                case .lockAmount,
                        .amountDragged,
                        .onDragRelease,
                        .quantityStepperAction:
                    return .none
                }
            }
        )
    }()
}

struct CafeoCoffeeAmountView: View {
    let store: Store<CafeoCoffeeAmountDomain.State, CafeoCoffeeAmountDomain.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(spacing: .cafeo(.spacing16)) {
                Text(CafeoIngredient.coffee.rawValue.localized)
                    .kerning(.cafeo(.standard))
                    .cafeoText(.mainLabel, color: .cafeoGray)
                    .textCase(.uppercase)

                VStack(spacing: .cafeo(.spacing10)) {
                    Text(viewStore.amount.format(to: "%.1f"))
                        .kerning(.cafeo(.large))
                        .cafeoText(.digitalLabel, color: .cafeoBeige)
//                        .accessibility(value: Text("\(viewStore.settings.unitConversion.rawValue)"))
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { drag in
                                    let dragDistance = drag.translation.width
                                    if dragDistance == 0 {
                                        viewStore.send(.onDragRelease)
                                    } else if dragDistance > 0 {
                                        viewStore.send(.amountDragged(.increment))
                                    } else if dragDistance < 0 {
                                        viewStore.send(.amountDragged(.decrement))
                                    }
                                }
                                .onEnded { _ in
                                    viewStore.send(.onDragRelease)
                                }
                        )

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
                .padding(.top, .cafeo(.spacing20))
                .accessibility(label: Text("Coffee Amount"))
            }
        }
    }
}
