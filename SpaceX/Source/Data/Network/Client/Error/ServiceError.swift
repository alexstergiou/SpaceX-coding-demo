//
//  ServiceError.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import Foundation

enum ServiceError: Error {
    case invalidRequest
    case invalidURL
    case invalidData
}
