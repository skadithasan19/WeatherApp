//
//  DateUtilities.swift
//  WeatherApp
//
//  Created by Adit Hasan on 6/21/23.
//

import Foundation

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
