//
//  CafeoButtonStyle.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-07-15.
//

import SwiftUI

struct CafeoButtonColor {
    var standard: Color
    var pressed: Color
    var disabled: Color
}

extension CafeoButtonColor {
    static var quantityStepper: Self {
        return .init(
            standard: CommonAssets.Colors.cafeoGray,
            pressed: CommonAssets.Colors.cafeoOrange,
            disabled: CommonAssets.Colors.cafeoGray
        )
    }
    static var clear: Self {
        return .init(standard: .clear, pressed: .clear, disabled: .clear)
    }
}

struct CafeoButtonStyle {
    var labelFont: CafeoFontStyle
    var labelColor: CafeoButtonColor
    var backgroundColor: CafeoButtonColor
    var size: CGSize
    var cornerRadius: CGFloat

    init(
        labelFont: CafeoFontStyle,
        labelColor: CafeoButtonColor,
        backgroundColor: CafeoButtonColor,
        size: CGSize,
        cornerRadius: CGFloat = 0
    ) {
        self.labelFont = labelFont
        self.labelColor = labelColor
        self.backgroundColor = backgroundColor
        self.size = size
        self.cornerRadius = cornerRadius
    }
}

extension CafeoButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(configuration: configuration, button: self)
    }

    struct Button: View {
        @Environment(\.isEnabled) private var isEnabled: Bool
        let configuration: ButtonStyle.Configuration
        let button: CafeoButtonStyle

        var body: some View {
            configuration.label
                .frame(width: self.button.size.width, height: self.button.size.height)
                .cafeoText(
                    self.button.labelFont,
                    color: self.isEnabled
                    ? configuration.isPressed
                    ? self.button.labelColor.pressed : self.button.labelColor.standard
                    : self.button.labelColor.disabled
                )
                .background(
                    self.isEnabled
                    ? configuration.isPressed
                    ? self.button.backgroundColor.pressed : self.button.backgroundColor.standard
                    : self.button.backgroundColor.disabled
                )
                .cornerRadius(self.button.cornerRadius)
        }
    }
}

extension View {
    func cafeoButtonStyle(_ style: CafeoButtonStyle) -> some View {
        self.buttonStyle(style)
    }
}
