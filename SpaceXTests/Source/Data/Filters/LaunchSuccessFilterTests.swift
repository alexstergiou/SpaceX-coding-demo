//
//  LaunchSuccessFilterTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import XCTest

@testable import SpaceX

final class LaunchSuccessFilterTests: XCTestCase {
    func testFilter() {
        let subject: LaunchSuccessFilter = LaunchSuccessFilter()
        XCTAssertTrue(subject.validate(launch: testLaunch(success: false)))
        XCTAssertTrue(subject.validate(launch: testLaunch(success: true)))

        subject.value = true
        XCTAssertFalse(subject.validate(launch: testLaunch(success: false)))
        XCTAssertTrue(subject.validate(launch: testLaunch(success: true)))

        let launches: [Launch] = [testLaunch(success: true), testLaunch(success: false)];
        XCTAssertEqual(subject.validate(launches: launches).count, 1)

        XCTAssertEqual(subject.title, L.Filters.showSuccess)
    }
}

extension LaunchSuccessFilterTests {
    func testLaunch(success: Bool) -> Launch {
        return Launch(name: "name",
                      timestamp: Date().timeIntervalSince1970,
                      links: Links(patch: nil,
                                   webcast: "https://www.spacex.com",
                                   article: "https://www.spacex.com",
                                   wikipedia: "https://www.spacex.com"),
                      rocketID: "identifier",
                      success: success)
    }
}
