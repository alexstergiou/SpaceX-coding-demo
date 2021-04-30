//
//  Launch.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import Foundation

final class Launch: Codable {
    let name: String
    let timestamp: TimeInterval
    let links: Links
    let rocketID: String
    let success: Bool?
    var rocket: Rocket?

    enum CodingKeys: String, CodingKey {
        case name
        case timestamp = "date_unix"
        case links
        case rocketID = "rocket"
        case success
    }

    init(name: String, timestamp: TimeInterval, links: Links, rocketID: String, success: Bool?) {
        self.name = name
        self.timestamp = timestamp
        self.links = links
        self.rocketID = rocketID
        self.success = success
    }
}

extension Launch {
    var date: Date {
        return Date(timeIntervalSince1970: timestamp)
    }
}

struct Links: Codable {
    let patch: Patch?
    let webcast: String?
    let article: String?
    let wikipedia: String?

    enum CodingKeys: String, CodingKey {
        case patch
        case webcast
        case article
        case wikipedia
    }
}

struct Patch: Codable {
    let small: String?
    let large: String?

    enum CodingKeys: String, CodingKey {
        case small
        case large
    }
}
