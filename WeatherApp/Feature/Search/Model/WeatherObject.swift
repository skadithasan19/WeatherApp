//
//  WeatherObject.swift
//  WeatherApp
//
//  Created by Adit Hasan on 6/17/23.
//

import Foundation

struct Coord: Codable {
    var lon: Double
    var lat: Double
}

struct WeatherEntry: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct Main: Codable {
    var temp: Double
    var feels_like: Double
    var temp_min: Double
    var temp_max: Double
    var pressure: Int
    var humidity: Int
}

struct Wind: Codable {
    var speed: Float?
    var deg: Int?
    var gust: Float?
}

struct Clouds: Codable {
    var all: Int
}

struct System: Codable {
    var type: Int
    var id: Int
    var country: String
    var sunrise: Int
    var sunset: Int
}

struct WeatherObject: Codable {
    var coord: Coord?
    var weather: [WeatherEntry]?
    var main: Main?
    var base: String?
    var visibility: Int?
    var wind: Wind?
    var clouds: Clouds?
    var dt: Int?
    var sys: System?
    var timezone: Int?
    var name: String?
    var cod: Int?
}


extension Double {
    func convertTemp(from inputTempType: UnitTemperature = .kelvin, to outputTempType: UnitTemperature = .fahrenheit) -> String {
        let mf = MeasurementFormatter()
        mf.numberFormatter.maximumFractionDigits = 0
        mf.unitOptions = .providedUnit
        let input = Measurement(value: self, unit: inputTempType)
        let output = input.converted(to: outputTempType)
        return mf.string(from: output)
    }
    
    func convertPressure(from inputTempType: UnitPressure = .bars, to outputTempType: UnitPressure = .inchesOfMercury) -> String {
        let mf = MeasurementFormatter()
        mf.numberFormatter.maximumFractionDigits = 0
        mf.unitOptions = .providedUnit
        let input = Measurement(value: self, unit: inputTempType)
        let output = input.converted(to: outputTempType)
        return mf.string(from: output)
    }
}

extension Int {
    func convertDistance(from inputTempType: UnitLength = .meters, to outputTempType: UnitLength = .miles) -> String {
        let mf = MeasurementFormatter()
        mf.numberFormatter.maximumFractionDigits = 0
        mf.unitOptions = .providedUnit
        let input = Measurement(value: Double(self), unit: inputTempType)
        let output = input.converted(to: outputTempType)
        return mf.string(from: output)
    }
}

extension WeatherEntry {
    var url: URL? {
        return URL(string: "https://openweathermap.org/img/wn/\(self.icon)@2x.png")
    }
}
