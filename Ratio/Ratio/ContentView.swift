//
//  ContentView.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-02-08.
//

import SwiftUI

struct ContentView: View {
    @State private var ratioDenominator: Double = 16
    @State private var coffeeAmount = Measurement(value: 0, unit: UnitMass.grams)
    @State private var waterAmount = Measurement(value: 250, unit: UnitMass.grams)
    @State private var index = 0
    @State private var coffeeIsLocked = true
    @State private var waterIsLocked = false

    private var coffeeIsLockedBinding: Binding<Bool> {
        Binding(get: {
            self.coffeeIsLocked
        }) {
            self.coffeeIsLocked = $0
            self.waterIsLocked.toggle()
        }
    }

    private var waterIsLockedBinding: Binding<Bool> {
        Binding(get: {
            self.waterIsLocked
        }) {
            self.waterIsLocked = $0
            self.coffeeIsLocked.toggle()
        }
    }

    var body: some View {
        Form {
            Section(header: Text("Unit of Measurement")) {
                Picker(selection: self.$index, label: Text(""), content: {
                    ForEach(0 ..< UnitOfMeasurement.allCases.count) {
                        let rawValue = UnitOfMeasurement.allCases[$0].rawValue
                        Text("\(rawValue)").tag(rawValue)
                    }
                })
                .pickerStyle(SegmentedPickerStyle())
            }

            Section(header: Text("Ratio")) {
                Stepper(value: self.$ratioDenominator, in: 1...1000, step: 1) { _ in
                    if self.waterIsLocked {
                        self.coffeeAmount = self.ratio * self.waterAmount
                    } else if self.coffeeIsLocked {
                        self.waterAmount = self.coffeeAmount / self.ratio
                    }
                } label: {
                    Text("1 / \(self.ratioDenominator, specifier: "%.0f")")
                        .font(.largeTitle)
                }
            }

            Section(header: Text("Coffee:")) {
                Toggle("Keep locked while changing ratio", isOn: self.coffeeIsLockedBinding)
                    .toggleStyle(LockToggleStyle())

                Stepper(
                    onIncrement: {
                        let newAmount = self.coffeeAmount.converted(to: self.unitOfMeasurement).value + 0.1
                        self.coffeeAmount = Measurement(value: newAmount, unit: self.unitOfMeasurement)
                    },
                    onDecrement: {
                        let amount = self.coffeeAmount.converted(to: self.unitOfMeasurement).value - 0.1
                        self.coffeeAmount = Measurement(value: amount, unit: self.unitOfMeasurement)
                    },
                    onEditingChanged: { _ in
                        self.updateWaterAmount()
                    },
                    label: {
                        Text("\(self.coffeeAmount.converted(to: self.unitOfMeasurement).value, specifier: "%.1f") \(self.unitOfMeasurement.symbol)")
                    }
                )

//                Stepper(value: self.$coffeeAmount.value, in: 0...999999999, step: 0.1) { _ in
//                    self.updateWaterAmount()
//                } label: {
//                    Text("\(self.coffeeAmount.converted(to: self.selectedUnit).value, specifier: "%.4f") \(self.selectedUnit.symbol)")
//                }
            }

            Section(header: Text("Water:")) {
                Toggle("Keep locked while changing ratio", isOn: self.waterIsLockedBinding)
                    .toggleStyle(LockToggleStyle())
                Stepper(value: self.$waterAmount.value, in: 0...999999999, step: 1) { _ in
                    self.updateCoffeeAmount()
                } label: {
                    Text("\(self.waterAmount.converted(to: self.unitOfMeasurement).value, specifier: "%.0f") \(self.unitOfMeasurement.symbol)")
                }
            }
        }
        .onAppear {
            self.coffeeAmount = self.ratio * self.waterAmount
        }
    }

    private func updateWaterAmount() {
        self.waterAmount = self.coffeeAmount / self.ratio
    }

    private func updateCoffeeAmount() {
        self.coffeeAmount = self.waterAmount * ratio
    }
}

// MARK: - Helper vars

extension ContentView {
    private var ratio: Double {
        1 / self.ratioDenominator
    }

    private var unitOfMeasurement: UnitMass {
        return UnitOfMeasurement.allCases[self.index].mass
    }

    enum UnitOfMeasurement: String, CaseIterable {
        case grams = "g"
        case ounces = "oz"
        var mass: UnitMass {
            switch self {
            case .grams: return .grams
            case .ounces: return .ounces
            }
        }
    }
}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
