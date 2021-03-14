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
                        viewStore.send(.unitConversionChanged)
                    }, label: {
                        Text("\(viewStore.conversionUnit.symbol)")
                    }).buttonStyle(PlainButtonStyle())
                }
                Section(header: Text("Ratio")) {
                    HStack {
                        Button(action: {
                            viewStore.send(.form(.set(\.activeRatioIdx, viewStore.activeRatioIdx - 1)))
                        }, label: {
                            Image(systemName: "minus.square")
                        }).buttonStyle(PlainButtonStyle())

                        Spacer()

                        Text("1 / \(viewStore.activeRatioDenominator, specifier: "%.0f")")

                        Spacer()

                        Button(action: {
                            viewStore.send(.form(.set(\.activeRatioIdx, viewStore.activeRatioIdx + 1)))
                        }, label: {
                            Image(systemName: "plus.square")
                        }).buttonStyle(PlainButtonStyle())
                    }.padding(.horizontal, 64)
                }

                Section(header: Text("Coffee:")) {
                    Toggle(
                        "Keep locked while changing ratio",
                        isOn: viewStore.binding(
                            keyPath: \.coffeeAmountIsLocked,
                            send: AppAction.form
                        )
                    ).toggleStyle(LockToggleStyle())

                    HStack {
                        Button(action: {
                            viewStore.send(.coffeeAmountChanged(.decrement))
                            //viewStore.send(.coffee(.set(\.coffeeAmount, 10)))
                        }, label: {
                            Image(systemName: "minus.square")
                        }).buttonStyle(PlainButtonStyle())
                        Spacer()
                        Text("\(viewStore.coffeeAmount, specifier: "%.1f") \(viewStore.conversionUnit.symbol)")
                        Spacer()
                        Button(action: {
                            viewStore.send(.coffeeAmountChanged(.increment))
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
                            keyPath: \.waterAmountIsLocked,
                            send: AppAction.form
                        )
                    ).toggleStyle(LockToggleStyle())

                    HStack {
                        Button(action: {
                            viewStore.send(.waterAmountChanged(.decrement))
                        }, label: {
                            Image(systemName: "minus.square")
                        }).buttonStyle(PlainButtonStyle())
                        Spacer()
                        Text("\(viewStore.waterAmount, specifier: "%.0f") \(viewStore.conversionUnit.symbol)")
                        Spacer()
                        Button(action: {
                            viewStore.send(.waterAmountChanged(.increment))
                        }, label: {
                            Image(systemName: "plus.square")
                        }).buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 64)
                }
            }
            .onAppear {
                viewStore.send(.form(.set(\.activeRatioIdx, 15)))
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
