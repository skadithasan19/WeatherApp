//
//  Numbers.swift
//  WeatherApp
//
//  Created by Adit Hasan on 6/23/23.
//

import Foundation

extension Float {
    /// Rounds the double to decimal places value
    func roundedBy(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (Double(self) * divisor).rounded() / divisor
    }
}
