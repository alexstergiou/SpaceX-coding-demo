//
//  DurationFilterTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import XCTest

@testable import SpaceX

final class DurationFilterTests: XCTestCase {

    func testFilter() {
        let subject: DurationFilter = DurationFilter()
        let startDate: Date = Date(timeIntervalSince1970: 100)
        let endDate: Date = Date(timeIntervalSince1970: 500)
        let launches: [Launch] = [testLaunch(date: startDate), testLaunch(date: endDate)]
        subject.update(launches: launches)

        XCTAssertTrue(subject.didInitialSetup)
        XCTAssertEqual(subject.startDate, startDate)
        XCTAssertEqual(subject.endDate, endDate)
        XCTAssertEqual(subject.minimumDate, startDate)
        XCTAssertEqual(subject.maximumDate, endDate)

        XCTAssertFalse(subject.validate(launch: testLaunch(date: Date(timeIntervalSince1970: 50))))
        XCTAssertTrue(subject.validate(launch: testLaunch(date: Date(timeIntervalSince1970: 200))))
        XCTAssertTrue(subject.validate(launch: testLaunch(date: Date(timeIntervalSince1970: 600))))
        XCTAssertFalse(subject.validate(launch: testLaunch(date: Date(timeIntervalSince1970: 600 + yearInterval))))

        let addedLaunches: [Launch] = [testLaunch(date: Date(timeIntervalSince1970: 600 + yearInterval)), testLaunch(date: Date(timeIntervalSince1970: 600))]
        XCTAssertEqual(subject.validate(launches: addedLaunches).count, 1)

        subject.endDate = Date(timeIntervalSince1970: 0)
        XCTAssertEqual(subject.validate(launches: addedLaunches).count, 0)

        XCTAssertEqual(subject.title, L.Filters.duration)
    }
}

extension DurationFilterTests {

    var yearInterval: TimeInterval {
        return 60.0 * 60.0 * 24.0 * 365.0
    }

    func testLaunch(date: Date) -> Launch {
        return Launch(name: "name",
                      timestamp: date.interval,
                      links: Links(patch: nil,
                                   webcast: "https://www.spacex.com",
                                   article: "https://www.spacex.com",
                                   wikipedia: "https://www.spacex.com"),
                      rocketID: "identifier",
                      success: true)
    }
}
