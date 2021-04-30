//
//  LaunchesEndpoint.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import Foundation

enum LaunchesEndpoint: Endpoint {
    case launches

    var httpMethod: HTTPMethod {
        switch self {
        case .launches:
            return .get
        }
    }

    var path: String {
        switch self {
        case .launches:
            return "launches"
        }
    }
}
