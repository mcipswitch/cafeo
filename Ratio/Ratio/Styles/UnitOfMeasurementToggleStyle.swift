//
//  UnitOfMeasurementToggleStyle.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-02-09.
//

import SwiftUI

struct UnitOfMeasurementToggleStyle: ToggleStyle {
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
