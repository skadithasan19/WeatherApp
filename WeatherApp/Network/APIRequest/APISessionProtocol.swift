//
//  APISessionProtocol.swift
//  WeatherApp
//
//  Created by Adit Hasan on 6/17/23.
//

import Foundation
import Combine

protocol RequestBuilder {
    var urlRequest: URLRequest { get }
}

protocol APISessionProtocol {
    func request<T: Decodable>(with builder: RequestBuilder) -> AnyPublisher<T, APIError>
}
