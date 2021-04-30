//
//  Filter.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import Foundation

enum FilterType: String, Codable {
    case duration
    case launchSuccess
    case orderAscending
}

protocol Filter: AnyObject, Codable {
    var type: FilterType { get }

    func validate(launch: Launch) -> Bool
    func validate(launches: [Launch]) -> [Launch]
    func update(launches: [Launch])
}

extension Filter {
    func update(launches: [Launch]) {}
}

