//
//  CafeoLockToggleStyle.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-02-08.
//

import SwiftUI

struct CafeoLockToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return
            Image.cafeo(configuration.isOn ? .lock : .lockOpen)
            .cafeoText(
                .quantityStepperLabel,
                color: configuration.isOn ? CommonAssets.Colors.cafeoOrange : CommonAssets.Colors.cafeoGray)
            .accessibilityValue(configuration.isOn ? Text("locked") : Text("unlocked"))
            .contentShape(Rectangle())
            .onTapGesture {
                configuration.isOn.toggle()
            }
    }
}
