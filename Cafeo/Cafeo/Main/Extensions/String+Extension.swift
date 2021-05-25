//
//  String+Extension.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-31.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
