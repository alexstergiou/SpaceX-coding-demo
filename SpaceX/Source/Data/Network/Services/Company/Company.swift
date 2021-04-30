//
//  Company.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import Foundation

struct Company: Codable {
    let name: String
    let founder: String
    let foundedYear: Int
    let employees: Int
    let launchSites: Int
    let valuation: Double
    
    enum CodingKeys: String, CodingKey {
        case name
        case founder
        case foundedYear = "founded"
        case employees
        case launchSites = "launch_sites"
        case valuation
    }

    init(name: String,
         founder: String,
         foundedYear: Int,
         employees: Int,
         launchSites: Int,
         valuation: Double) {
        self.name = name
        self.founder = founder
        self.foundedYear = foundedYear
        self.employees = employees
        self.launchSites = launchSites
        self.valuation = valuation
    }
}
