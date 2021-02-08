//
//  ContentView.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-02-08.
//

import SwiftUI

struct ContentView: View {
    @State private var ratio = 16
    @State private var coffee: Double = 15.0
    @State private var water: Double = 250.0

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
            Section(header: Text("Ratio")) {
                Stepper(value: self.$ratio, in: 0...1000, step: 1) { editingChanged in

                    let ratio = 1 / Double(self.ratio)

                    if self.waterIsLocked {
                        self.coffee = ratio * self.water
                    } else if self.coffeeIsLocked {
                        self.water = self.coffee / ratio
                    }

                } label: {
                    Text("1 / \(self.ratio)")
                }
            }

            Section(header: Text("Coffee:")) {
                Toggle("Keep locked while changing ratio", isOn: self.coffeeIsLockedBinding)
                    .toggleStyle(LockToggleStyle())

                Stepper(value: self.$coffee, in: 0...1000000, step: 0.1) { editingChanged in
                    // do something here
                } label: {
                    Text("\(self.coffee, specifier: "%.1f") g")
                }
            }

            Section(header: Text("Water:")) {
                Toggle("Keep locked while changing ratio", isOn: self.waterIsLockedBinding)
                    .toggleStyle(LockToggleStyle())

                Stepper(value: self.$water, in: 0...1000000, step: 1) { editingChanged in
                    // do something here
                } label: {
                    Text("\(self.water, specifier: "%.0f") g")
                }
            }
        }
    }
}

// MARK: - LockToggleStyle

struct LockToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            configuration.label
                .font(.caption)
            Spacer()
            Image(systemName: configuration.isOn ? "lock.fill" : "lock.open")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 15, height: 15)
                .onTapGesture { configuration.isOn.toggle() }
        }
        .foregroundColor(configuration.isOn ? .black : .gray)
    }
}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
