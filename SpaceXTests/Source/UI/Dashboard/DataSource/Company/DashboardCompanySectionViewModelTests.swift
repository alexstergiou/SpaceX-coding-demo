//
//  DashboardCompanySectionViewModelTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import XCTest

@testable import SpaceX

final class DashboardCompanySectionViewModelTests: XCTestCase {

    func testUpdate() {
        let subject: DashboardCompanySectionViewModel = DashboardCompanySectionViewModel()
        subject.update(with: mockCompany)
        XCTAssertEqual(subject.items.count, 1)
        XCTAssertEqual(subject.numberOfItems, 1)
    }
}

extension DashboardCompanySectionViewModelTests {
    var mockCompany: Company {
        return Company(name: "name",
                       founder: "founder",
                       foundedYear: 2020,
                       employees: 10,
                       launchSites: 20,
                       valuation: 2000)
    }
}
