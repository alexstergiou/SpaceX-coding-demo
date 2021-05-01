//
//  DurationFilter.swift
//  SpaceX
//
//  Created by Alex Stergiou on 30/04/2021.
//

import Foundation

protocol StartEndDateItem: AnyObject {
    var title: String { get }
    var minimumDate: Date { get set }
    var maximumDate: Date { get set }
    var startDate: Date { get set }
    var endDate: Date { get set }
}

final class DurationFilter: Filter, StartEndDateItem {
    let type: FilterType

    var startDate: Date = Date()
    var endDate: Date = Date()
    var minimumDate: Date = Date()
    var maximumDate: Date = Date()
    var didInitialSetup: Bool = false

    init(type: FilterType = .duration) {
        self.type = type
    }

    var title: String {
        return L.Filters.duration
    }

    func update(launches: [Launch]) {
        if didInitialSetup == true { return }

        let sortedLaunches: [Launch] = launches.sorted { $0.timestamp < $1.timestamp }
        if let first = sortedLaunches.first {
            startDate = first.timestamp.date
            minimumDate = startDate
        }
        if let last = sortedLaunches.last {
            endDate = last.timestamp.date
            maximumDate = endDate
        }
        didInitialSetup = true
    }

    func validate(launch: Launch) -> Bool {
        guard startDate.interval <= endDate.interval else { return false }
        return launch.date.isBetween(startDate: startDate, endDate: endDate.byAdding(years: 1))
    }

    func validate(launches: [Launch]) -> [Launch] {
        return launches.filter { validate(launch: $0) }
    }
}
