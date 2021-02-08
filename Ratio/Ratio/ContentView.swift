//
//  ContentView.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-02-08.
//

import SwiftUI

struct ContentView: View {
    @State private var ratio = 1
    @State private var coffee: Double = 15.0
    @State private var water = 250

    var body: some View {
        Form {
            Section(header: Text("Ratio")) {
                Picker(selection: $ratio, label: Text("Picker")) {
                    Text("1/14").tag(0)
                    Text("1/16").tag(1)
                    Text("1/18").tag(2)
                }.pickerStyle(SegmentedPickerStyle())
            }

            Section(header: Text("Coffee:")) {
                Stepper("\(self.coffee, specifier: "%.1f") g", onIncrement: {
                    self.coffee += 0.1
                },
                onDecrement: {
                    self.coffee -= 0.1
                })
            }

            Section(header: Text("Water:")) {
                Stepper("\(self.water) g", onIncrement: {
                    self.water += 1
                },
                onDecrement: {
                    self.water -= 1
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
