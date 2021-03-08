//
//  ContentView.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-02-08.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            Form {
                Section(header: Text("Unit of Measurement")) {
                    Button(action: {
                        viewStore.send(.unitChanged)
                    }, label: {
                        Text("\(viewStore.unit.symbol)")
                    }).buttonStyle(PlainButtonStyle())
                }
                Section(header: Text("Ratio")) {
                    HStack {
                        Button(action: {
                            viewStore.send(.form(.set(\.ratioDenominator, viewStore.ratioDenominator - 1)))
                        }, label: {
                            Image(systemName: "minus.square")
                        }).buttonStyle(PlainButtonStyle())

                        Spacer()

                        Text("1 / \(viewStore.ratioDenominator, specifier: "%.0f")")

                        Spacer()

                        Button(action: {
                            viewStore.send(.form(.set(\.ratioDenominator, viewStore.ratioDenominator + 1)))
                        }, label: {
                            Image(systemName: "plus.square")
                        }).buttonStyle(PlainButtonStyle())
                    }.padding(.horizontal, 64)
                }

                Section(header: Text("Coffee:")) {
                    Toggle(
                        "Keep locked while changing ratio",
                        isOn: viewStore.binding(
                            keyPath: \.lockCoffeeAmount,
                            send: AppAction.form
                        )
                    ).toggleStyle(LockToggleStyle())

                    HStack {
                        Button(action: {
                            viewStore.send(.coffeeDecrementButtonTapped)
                            //viewStore.send(.coffee(.set(\.coffeeAmount, 10)))
                        }, label: {
                            Image(systemName: "minus.square")
                        }).buttonStyle(PlainButtonStyle())
                        Spacer()
                        Text("\(viewStore.coffeeAmount, specifier: "%.1f") \(viewStore.unit.symbol)")
                        Spacer()
                        Button(action: {
                            viewStore.send(.coffeeIncrementButtonTapped)
                        }, label: {
                            Image(systemName: "plus.square")
                        }).buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 64)
                }

                Section(header: Text("Water:")) {
                    Toggle(
                        "Keep locked while changing ratio",
                        isOn: viewStore.binding(
                            keyPath: \.lockWaterAmount,
                            send: AppAction.form
                        )
                    ).toggleStyle(LockToggleStyle())

                    HStack {
                        Button(action: {
                            viewStore.send(.waterDecrementButtonTapped)
                        }, label: {
                            Image(systemName: "minus.square")
                        }).buttonStyle(PlainButtonStyle())
                        Spacer()
                        Text("\(viewStore.waterAmount, specifier: "%.0f") \(viewStore.unit.symbol)")
                        Spacer()
                        Button(action: {
                            viewStore.send(.waterIncrementButtonTapped)
                        }, label: {
                            Image(systemName: "plus.square")
                        }).buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 64)
                }
            }
            .onAppear {
                viewStore.send(.form(.set(\.ratioDenominator, 16)))
            }
        }
    }
}

// MARK: - ViewStore + Extension

extension ViewStore {
    func binding<Value>(
        keyPath: WritableKeyPath<State, Value>,
        send action: @escaping (FormAction<State>) -> Action
    ) -> Binding<Value> where Value: Hashable {
        self.binding(
            get: { $0[keyPath: keyPath] },
            send: { action(.init(keyPath, $0)) }
        )
    }
}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: Store(initialState: AppState(),
                                 reducer: appReducer,
                                 environment: AppEnvironment()
        ))
    }
}
