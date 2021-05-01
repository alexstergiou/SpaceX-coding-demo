//
//  OrderAscendingFilterTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import XCTest

@testable import SpaceX

final class OrderAscendingFilterTests: XCTestCase {

    func testFilter() {
        let subject: OrderAscendingFilter = OrderAscendingFilter()

        let launch1: Launch = testLaunch(identifier: "ID1", timestamp: 100)
        let launch2: Launch = testLaunch(identifier: "ID2", timestamp: 200)

        XCTAssertTrue(subject.validate(launch: launch1))

        let launches: [Launch] = [launch1, launch2];
        var sortedLaunches: [Launch] = subject.validate(launches: launches)
        XCTAssertEqual(sortedLaunches.first?.rocketID, "ID1")
        XCTAssertEqual(sortedLaunches.last?.rocketID, "ID2")

        subject.value = false

        sortedLaunches = subject.validate(launches: launches)
        XCTAssertEqual(sortedLaunches.first?.rocketID, "ID2")
        XCTAssertEqual(sortedLaunches.last?.rocketID, "ID1")

        XCTAssertEqual(subject.title, L.Filters.ascending)
    }
}

extension OrderAscendingFilterTests {
    func testLaunch(identifier: String, timestamp: TimeInterval) -> Launch {
        return Launch(name: "name",
                      timestamp: timestamp,
                      links: Links(patch: nil,
                                   webcast: "https://www.spacex.com",
                                   article: "https://www.spacex.com",
                                   wikipedia: "https://www.spacex.com"),
                      rocketID: identifier,
                      success: true)
    }
}
