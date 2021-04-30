//
//  Endpoint.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import Foundation

enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

enum BaseURL {
    static let value: String = "https://api.spacexdata.com/v4/"
}

protocol Endpoint {
    var httpMethod: HTTPMethod { get }
    var path: String { get }
    var request: URLRequest? { get }
}

extension Endpoint {
    var request: URLRequest? {
        return EndpointRequestProvider().request(url: self.url, httpMethod: self.httpMethod)
    }

    var url: URL? {
        let string = BaseURL.value + self.path

        return URL(string: string)
    }
}
