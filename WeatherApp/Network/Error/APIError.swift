//
//  APIError.swift
//  WeatherApp
//
//  Created by Adit Hasan on 6/17/23.
//

import Foundation

enum APIError: Error {
    case authorizationError(description: String)
    case decodingError(error: Error?)
    case validationError(error: Error)
    case httpError(response: HTTPURLResponse, builder: RequestBuilder)
    case noResponse
    case unknown(description: String)

    var errorDescription: String? {
        switch self {
        case .authorizationError:
            return AuthorizationError.defaultAuthError
        case .decodingError:
            return DecodingError.defaultDecodingError
        case .validationError:
            return DecodingError.defaultDecodingError
        case .noResponse:
            return HTTPError.noResponse
        case .unknown(let description):
            return description
        case .httpError(response: let response, _):
            switch response.statusCode {
            case 404:
                return HTTPError.statusCode404
            default:
                return HTTPError.defaultHttpError
            }
        }
    }
}

extension APIError {
    enum DecodingError {
        static let defaultDecodingError = "There was a problem decoding the data from the server. Please try again"
    }
    enum HTTPError {
        static let statusCode404 = "The requested resource was not found"
        static let noResponse = "It looks like the server is not responding."
        static let defaultHttpError = "It looks like there was a problem with your request, please try again."
        static let unknownError = "It looks like there was a problem with your request."
    }
    enum AuthorizationError {
        static let defaultAuthError = "There was an error authenticating your request, please try again"
    }
}
