//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Adit Hasan on 6/17/23.
//

import Foundation
import Combine

protocol WeatherServiceProtocol {
    var apiSession: APISessionProtocol { get }
    func getWeatherDetail(city: String) -> AnyPublisher<WeatherObject, APIError>
    func getWeatherDetail(city: String, state: String) -> AnyPublisher<WeatherObject, APIError>
    func getWeatherDetail(city: String, state: String, country: String) -> AnyPublisher<WeatherObject, APIError>
    func getWeatherDetailBy(lat: Double, lon: Double) -> AnyPublisher<WeatherObject, APIError>
}

extension WeatherServiceProtocol {
    func getWeatherDetail(city: String) -> AnyPublisher<WeatherObject, APIError> {
        apiSession.request(with: Endpoint.weatherDetailBy(city: city))
    }
    
    func getWeatherDetail(city: String, state: String) -> AnyPublisher<WeatherObject, APIError> {
        apiSession.request(with: Endpoint.weatherDetailWith(city: city, state: state))
    }
    
    func getWeatherDetail(city: String, state: String, country: String) -> AnyPublisher<WeatherObject, APIError> {
        apiSession.request(with: Endpoint.weatherDetailIncluding(city: city, state: state, country: country))
    }

    func getWeatherDetailBy(lat: Double, lon: Double) -> AnyPublisher<WeatherObject, APIError> {
        apiSession.request(with: Endpoint.coordinate(lat, lon))
    }
}
