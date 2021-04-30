//
//  Date+Helpers.swift
//  SpaceX
//
//  Created by Alex Stergiou on 30/04/2021.
//

import Foundation

enum DateFormat: String {
    case year = "yyyy"
    case dateTime = "dd/MM/yyyy hh:mm"
}

extension Date {
    func isBetween(startDate: Date, endDate: Date) -> Bool {
        let interval: TimeInterval = self.timeIntervalSince1970

        return startDate.timeIntervalSince1970 <= interval && interval <= endDate.timeIntervalSince1970
    }

    func rangeOfYears(for date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year], from: self, to: date)

        return components.year ?? 0
    }

    var year: Int {
        return Calendar.current.component(.year, from: self)
    }

    var yearString: String {
        return "\(year)"
    }

    static func with(year: Int) -> Date {
        var components: DateComponents = DateComponents()

        components.year = year

        return Calendar.current.date(from: components) ?? Date()
    }

    func byAdding(years: Int) -> Date {
        return Date.with(year: year + years)
    }
}
