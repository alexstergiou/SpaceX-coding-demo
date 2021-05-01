//
//  DashboardCompanyItemViewModelTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import XCTest

@testable import SpaceX

final class DashboardCompanyItemViewModelTests: XCTestCase {

    func testProperties() {
        let subject: DashboardCompanyItemViewModel = DashboardCompanyItemViewModel(company: mockCompany)
        XCTAssertEqual(subject.name, "name")
        XCTAssertEqual(subject.founder, "founder")
        XCTAssertEqual(subject.foundedYear, 2020)
        XCTAssertEqual(subject.employees, 10)
        XCTAssertEqual(subject.launchSites, 20)
        XCTAssertEqual(subject.valuation, 2000)

        XCTAssertEqual(subject.numberFormatter.maximumFractionDigits, 0)
        XCTAssertEqual(subject.numberFormatter.minimumFractionDigits, 0)
        XCTAssertEqual(subject.numberFormatter.locale, Locale.current)
        XCTAssertEqual(subject.numberFormatter.numberStyle, .currency)

        XCTAssertEqual(subject.valuationFormattedString, "$2,000") //Will fail if simulator is not in US Locale.
    }
}

extension DashboardCompanyItemViewModelTests {
    var mockCompany: Company {
        return Company(name: "name",
                       founder: "founder",
                       foundedYear: 2020,
                       employees: 10,
                       launchSites: 20,
                       valuation: 2000)
    }
}
