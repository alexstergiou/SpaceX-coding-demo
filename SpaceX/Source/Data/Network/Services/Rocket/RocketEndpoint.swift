//
//  RocketEndpoint.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import Foundation

enum RocketEndpoint: Endpoint {
    case details(String)

    var httpMethod: HTTPMethod {
        switch self {
        case .details:
            return .get
        }
    }

    var path: String {
        switch self {
        case .details(let identifier):
            return "rockets/\(identifier)"
        }
    }
}
