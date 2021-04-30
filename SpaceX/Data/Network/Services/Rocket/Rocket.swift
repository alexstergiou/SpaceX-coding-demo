//
//  Rocket.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import Foundation

struct Rocket: Codable {
    let name: String
    let type: String
    let description: String

    enum CodingKeys: String, CodingKey {
        case name
        case type
        case description
    }
}
