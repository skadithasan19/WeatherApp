//
//  Endpoint.swift
//  WeatherApp
//
//  Created by Adit Hasan on 6/17/23.
//

import Foundation

enum Endpoint {
    case weatherDetailBy(city: String)
    case weatherDetailWith(city: String, state: String)
    case weatherDetailIncluding(city: String, state: String, country: String)
    case coordinate(Double, Double)
}

extension Endpoint: RequestBuilder {
    var urlRequest: URLRequest {
        switch self {
        case .weatherDetailBy(let city):
            guard let url =  URLs.weatherDetailBy(city: city).url else { preconditionFailure("Invalid URL format") }
            print(url)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            return request
        case .weatherDetailWith(let city, let state):
            guard let url =  URLs.weatherDetailWith(city: city, state: state).url else { preconditionFailure("Invalid URL format") }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            return request
        case .weatherDetailIncluding(let city, let state, let country):
            guard let url =  URLs.weatherDetailIncluding(city: city, state: state, country: country).url else { preconditionFailure("Invalid URL format") }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            return request
        case .coordinate(let lat, let lon):
            guard let url =  URLs.coordiate(lat, lon).url else { preconditionFailure("Invalid URL format") }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            return request
        }

    }
}
