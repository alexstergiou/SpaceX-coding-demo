//
//  Date+HelpersTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 01/05/2021.
//

import XCTest

@testable import SpaceX

final class Date_HelpersTests: XCTestCase {

    func testFunctions() {
        var date1: Date = Date(timeIntervalSince1970: 100)
        var date2: Date = Date(timeIntervalSince1970: 300)
        var date3: Date = Date(timeIntervalSince1970: 200)
        XCTAssertTrue(date3.isBetween(startDate: date1, endDate: date2))
        XCTAssertFalse(date3.isBetween(startDate: date2, endDate: date1))

        date3 = Date(timeIntervalSince1970: 400)
        XCTAssertFalse(date3.isBetween(startDate: date1, endDate: date2))

        date3 = Date(timeIntervalSince1970: 50)
        XCTAssertFalse(date3.isBetween(startDate: date1, endDate: date2))

        let yearInterval: TimeInterval = 60.0 * 60.0 * 24.0 * 365.0
        date1 = Date(timeIntervalSince1970: 100)
        date2 = Date(timeIntervalSince1970: 100.0 + (yearInterval * 4))
        XCTAssertEqual(date1.rangeOfYears(for: date2), 3)
        XCTAssertEqual(date2.year, 1973)
        XCTAssertEqual(date2.yearString, "1973")

        XCTAssertEqual(Date.with(year: 2021).year, 2021)
        XCTAssertEqual(Date.with(year: 2021).byAdding(years: 3).year, 2024)
    }
}
