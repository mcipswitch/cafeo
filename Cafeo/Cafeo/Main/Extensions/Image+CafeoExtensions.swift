//
//  Image+CafeoExtensions.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-07-15.
//

import SwiftUI

/// Represents an icon within the Cafeo iOS design system
struct CafeoIcon: Equatable {
    var style: CafeoIcon.Style

    enum Style: Equatable {
        case sfSymbol(String)
        case custom(String)
    }
}

// MARK: - SF Symbols

extension CafeoIcon {

    static var plus: Self {
        return .init(style: .sfSymbol("plus"))
    }

    static var minus: Self {
        return .init(style: .sfSymbol("minus"))
    }

    static var lock: Self {
        return .init(style: .sfSymbol("lock"))
    }

    static var lockOpen: Self {
        return .init(style: .sfSymbol("lock.open"))
    }
}

extension Image {
    static func cafeo(_ icon: CafeoIcon, fontStyle: CafeoFontStyle) -> some View {
        switch icon.style {
        case let.sfSymbol(name):
            return Image(systemName: name)
                .font(.system(size: fontStyle.size))

        case .custom(_):
            fatalError("Implement and test this when addign the first custom icon")
        }
    }

    static func cafeo(_ icon: CafeoIcon) -> Image {
        switch icon.style {
        case let.sfSymbol(name):
            return Image(systemName: name)

        case .custom(_):
            fatalError("Implement and test this when addign the first custom icon")
        }
    }
}
