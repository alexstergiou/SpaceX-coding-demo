//
//  OrderAscendingFilter.swift
//  SpaceX
//
//  Created by Alex Stergiou on 30/04/2021.
//

import Foundation

final class OrderAscendingFilter: Filter, BooleanItem {
    let type: FilterType
    var value: Bool = true

    init(type: FilterType = .orderAscending) {
        self.type = type
    }

    var title: String {
        return L.Filters.ascending
    }

    func validate(launch: Launch) -> Bool {
        return true
    }

    func validate(launches: [Launch]) -> [Launch] {
        if value {
            return launches.sorted { $0.timestamp < $1.timestamp }
        }
        return launches.sorted { $0.timestamp > $1.timestamp }
    }
}
