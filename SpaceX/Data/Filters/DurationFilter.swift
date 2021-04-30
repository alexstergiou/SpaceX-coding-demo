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
        return NSLocalizedString("Duration", comment: "")
    }

    func validate(launch: Launch) -> Bool {
        guard startDate.timeIntervalSince1970 <= endDate.timeIntervalSince1970 else { return false }
        return launch.date.isBetween(startDate: startDate, endDate: endDate.byAdding(years: 1))
    }

    func update(launches: [Launch]) {
        if didInitialSetup == true { return }

        let sortedLaunches: [Launch] = launches.sorted { $0.timestamp < $1.timestamp }
        if let first = sortedLaunches.first {
            startDate = Date(timeIntervalSince1970: first.timestamp)
            minimumDate = startDate
        }
        if let last = sortedLaunches.last {
            endDate = Date(timeIntervalSince1970: last.timestamp)
            maximumDate = endDate
        }
        didInitialSetup = true
    }

    func validate(launches: [Launch]) -> [Launch] {
        return launches.filter { validate(launch: $0) }
    }
}
