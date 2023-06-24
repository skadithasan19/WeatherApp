//
//  URLs.swift
//  WeatherApp
//
//  Created by Adit Hasan on 6/17/23.
//

import Foundation

enum URLs {
    case weatherDetailBy(city: String)
    case weatherDetailWith(city: String, state: String)
    case weatherDetailIncluding(city: String, state: String, country: String)
    case coordiate(Double, Double)
    
    static let apiKey = "6560470dce0a001f744ac78c1fac9fe6"
    
    var url: URL? {
        switch self {
        case .weatherDetailBy(let input):
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.openweathermap.org"
            components.path = "/data/2.5/weather"

            components.queryItems = [
                URLQueryItem(name: "q", value: input),
                URLQueryItem(name: "appid", value: URLs.apiKey)
            ]
            
            return components.url

        case .coordiate(let lat, let lon):
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.openweathermap.org"
            components.path = "/data/2.5/weather"

            components.queryItems = [
                URLQueryItem(name: "lat", value: "\(lat)"),
                URLQueryItem(name: "lon", value: "\(lon)"),
                URLQueryItem(name: "appid", value: URLs.apiKey)
            ]
            
            return components.url
        case .weatherDetailWith(city: let city, state: let state):
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.openweathermap.org"
            components.path = "/data/2.5/weather"

            components.queryItems = [
                URLQueryItem(name: "q", value: "\(city),\(state)"),
                URLQueryItem(name: "appid", value: URLs.apiKey)
            ]
            return components.url
        case .weatherDetailIncluding(city: let city, state: let state, country: let country):
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.openweathermap.org"
            components.path = "/data/2.5/weather"

            components.queryItems = [
                URLQueryItem(name: "q", value: "\(city),\(state),\(country)"),
                URLQueryItem(name: "appid", value: URLs.apiKey)
            ]
            return components.url
        }
    }
}
