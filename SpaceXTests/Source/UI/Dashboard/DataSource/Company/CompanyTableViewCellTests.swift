//
//  CompanyTableViewCellTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import XCTest

@testable import SpaceX

final class CompanyTableViewCellTests: XCTestCase {

    func testUpdate() {
        let subject: CompanyTableViewCell = CompanyTableViewCell(style: .default, reuseIdentifier: CompanyTableViewCell.reuseIdentifier())
        let item: DashboardCompanyItemViewModel = DashboardCompanyItemViewModel(company: mockCompany)

        subject.update(with: TestCompanyDashboardItem())

        XCTAssertNil(subject.titleLabel.text)

        subject.update(with: item)

        XCTAssertEqual(subject.titleLabel.text, "name was founded by founder in 2020. It has now 10 employees, 20 launch sites, and is valued at USD $2,000") //Will fail if simulator is not in US Locale.
    }
}

extension CompanyTableViewCellTests {
    var mockCompany: Company {
        return Company(name: "name",
                       founder: "founder",
                       foundedYear: 2020,
                       employees: 10,
                       launchSites: 20,
                       valuation: 2000)
    }
}
