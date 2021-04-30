//
//  EndpointRequestProvider.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import Foundation

struct EndpointRequestProvider {
    func request(url: URL?, httpMethod: HTTPMethod) -> URLRequest? {
        guard let url = url else {
            return nil
        }
        let headers: [String: String] = [:] // Add any common headers here.
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = httpMethod.rawValue

        return urlRequest
    }
}
