//
//  Color+Extension.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-09.
//

import SwiftUI

extension UIColor {
    public static let cafeoOrange = UIColor(named: "orange")
}

extension Color {
    public static let cafeoOrange = Color("orange")
    public static let cafeoBeige = Color("beige")
    public static let cafeoBlack05 = Color("black05")
    public static let cafeoGray = Color("gray")
    public static let cafeoHighlightDark = Color("highlightDark")
    public static let cafeoHighlightLight = Color("highlightLight")
    public static let cafeoPrimaryBackgroundDark = Color("primaryBackgroundDark")
    public static let cafeoPrimaryBackgroundLight = Color("primaryBackgroundLight")
    public static let cafeoShadowDark = Color("shadowDark")
    public static let cafeoShadowLight = Color("shadowLight")
    public static let cafeoWhite03 = Color("white03")

//    public static let primaryBackgroundDark = Color(#colorLiteral(red: 0.1215686275, green: 0.1254901961, blue: 0.1450980392, alpha: 1))
//    public static let primaryBackgroundLight = Color(#colorLiteral(red: 0.1568627451, green: 0.1725490196, blue: 0.2, alpha: 1))
//
//    public static let cafeoBeige = Color(#colorLiteral(red: 0.7411764706, green: 0.7333333333, blue: 0.5882352941, alpha: 1))
//    public static let cafeoGray = Color(#colorLiteral(red: 0.5647058824, green: 0.5803921569, blue: 0.6274509804, alpha: 1))
//    public static let cafeoOrange = Color(#colorLiteral(red: 0.8980392157, green: 0.3607843137, blue: 0, alpha: 1)) //E55C00
//
//    public static let cafeoHighlight00 = Color(#colorLiteral(red: 0.1607843137, green: 0.1725490196, blue: 0.1960784314, alpha: 1)) //292C32
//    public static let cafeoHighlight1 = Color(#colorLiteral(red: 0.2470588235, green: 0.262745098, blue: 0.2901960784, alpha: 1)) //3F434A
//
//    public static let cafeoShadowDark00 = Color(#colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.01568627451, alpha: 1)) //040404
//    public static let cafeoShadowDark1 = Color(#colorLiteral(red: 0.09411764706, green: 0.09803921569, blue: 0.1019607843, alpha: 1)) //18191A
//
//    public static let black05 = Color.black.opacity(0.5)
//    public static let white03 = Color.white.opacity(0.3)
}

extension Color {
    /// Returns the corresponding Cafeo color
    static func cafeo(_ color: Color) -> Color {
        return color
    }
}
