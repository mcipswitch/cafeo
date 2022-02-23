//
//  Gradient+Extension.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-13.
//

import SwiftUI

extension LinearGradient {
    static let cafeoOrange = LinearGradient(
        gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5568627451, green: 0.2, blue: 0, alpha: 1)), Color(#colorLiteral(red: 0.8980392157, green: 0.3803921569, blue: 0, alpha: 1))]),
        startPoint: .leading,
        endPoint: .trailing
    )

    static let cafeoChrome = LinearGradient(
        gradient: Gradient(colors: [Color(#colorLiteral(red: 0.137254902, green: 0.1490196078, blue: 0.168627451, alpha: 1)), Color(#colorLiteral(red: 0.2431372549, green: 0.262745098, blue: 0.2941176471, alpha: 1)), Color(#colorLiteral(red: 0.137254902, green: 0.1490196078, blue: 0.168627451, alpha: 1))]),
        startPoint: .top,
        endPoint: .bottom
    )

    static let cafeoIngredientAmountButtonStroke = LinearGradient(
        gradient: Gradient(colors: [.primaryBackgroundDark, Color(#colorLiteral(red: 0.1960784314, green: 0.2117647059, blue: 0.231372549, alpha: 1))]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
