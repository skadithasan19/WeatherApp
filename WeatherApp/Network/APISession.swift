//
//  APISession.swift
//  WeatherApp
//
//  Created by Adit Hasan on 6/17/23.
//

import Combine
import Foundation

protocol URLSessionProtocol {
    func dataTaskPublisher(for: URLRequest) -> URLSession.DataTaskPublisher
}

extension URLSession: URLSessionProtocol {}

struct APISession: APISessionProtocol {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func request<T>(with builder: RequestBuilder) -> AnyPublisher<T, APIError> where T : Decodable {
        return session.dataTaskPublisher(for: builder.urlRequest)
            .tryMap { result in
                let decoder = JSONDecoder()
                guard let urlResponse = result.response as? HTTPURLResponse else {
                    throw APIError.unknown(description: "Unknown Error: 0")
                }
                
                if (200...299).contains(urlResponse.statusCode) {
                    do {
                        return try decoder.decode(T.self, from: result.data)
                    } catch DecodingError.keyNotFound(_, let context),
                            DecodingError.valueNotFound(_, let context),
                            DecodingError.typeMismatch(_, let context),
                            DecodingError.dataCorrupted(let context) {
                        print("Error decoding response: \(context.debugDescription)")
                        throw APIError.decodingError(error: nil)
                    } catch {
                        throw APIError.decodingError(error: error)
                    }
                } else {
                    throw APIError.httpError(response: urlResponse, builder: builder)
                }
            }
            .mapError { error in
                switch error {
                case let apiError as APIError:
                    return apiError
                case let decodingError as DecodingError:
                    return APIError.decodingError(error: decodingError)
                default:
                    return APIError.unknown(description: error.localizedDescription)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
