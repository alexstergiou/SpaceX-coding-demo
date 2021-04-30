//
//  CompanyEndpoint.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import Foundation

enum CompanyEndpoint: Endpoint {
    case company

    var httpMethod: HTTPMethod {
        switch self {
        case .company:
            return .get
        }
    }

    var path: String {
        switch self {
        case .company:
            return "company"
        }
    }
}
