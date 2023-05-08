//
//  Double+Extension.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-13.
//

import Foundation

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
