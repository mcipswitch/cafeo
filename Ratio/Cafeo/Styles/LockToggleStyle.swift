//
//  LockToggleStyle.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-02-08.
//

import SwiftUI

struct LockToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return
            Image(systemName: configuration.isOn ? "lock" : "lock.open")
            .accessibility(value: configuration.isOn ? Text("locked") : Text("unlocked"))
            .foregroundColor(configuration.isOn ? .cafeoOrange : .cafeoGray)
            .font(.system(size: 16, weight: .medium))
            .contentShape(Rectangle())
            .onTapGesture {
                configuration.isOn.toggle()
            }
    }
}
