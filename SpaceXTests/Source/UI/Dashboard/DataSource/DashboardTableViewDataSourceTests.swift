//
//  DashboardTableViewDataSourceTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 01/05/2021.
//

import XCTest

@testable import SpaceX

final class MockDashboardTableViewSelectionDelegate: DashboardTableViewSelectionDelegate {

    var didSelectCalled: Bool = false
    func didSelect(item: DashboardItem) {
        didSelectCalled = true
    }
}

final class DashboardTableViewDataSourceTests: XCTestCase {

    var subject: DashboardTableViewDataSource!
    var dependenciesHelper: DependenciesHelper!

    override func setUpWithError() throws {
        dependenciesHelper = DependenciesHelper()
        subject = DashboardTableViewDataSource(services: dependenciesHelper.services)
    }

    override func tearDownWithError() throws {
        subject = nil
        dependenciesHelper = nil
    }

    func testSetupTableView() {
        let tableView: UITableView = UITableView()
        subject.setup(tableView: tableView)

        XCTAssertNotNil(tableView.dataSource)
        XCTAssertNotNil(tableView.delegate)
        XCTAssertNotNil(tableView.tableFooterView)
        XCTAssertEqual(tableView.rowHeight, UITableView.automaticDimension)
    }

    func testUpdateCompany() {
        let value: Int? = subject.update(with: mockCompany)
        XCTAssertEqual(subject.companySection.items.count, 1)
        XCTAssertEqual(value, 0)
    }

    func testUpdateLaunches() {
        let value: Int? = subject.update(with: [mockLaunch()])
        XCTAssertEqual(subject.launchesSection.items.count, 1)
        XCTAssertEqual(value, 1)
    }

    func testSectionAtIndex() {
        XCTAssertNil(subject.section(at: 5))
    }

    func testNumberOfSections() {
        let tableView: UITableView = UITableView()
        subject.setup(tableView: tableView)

        _ = subject.update(with: mockCompany)
        _ = subject.update(with: [mockLaunch(), mockLaunch()])

        XCTAssertEqual(subject.numberOfSections(in: tableView), 2)
        XCTAssertEqual(subject.tableView(tableView, numberOfRowsInSection: 0), 1)
        XCTAssertEqual(subject.tableView(tableView, numberOfRowsInSection: 1), 2)

        guard let _ = subject.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? CompanyTableViewCell else {
            XCTFail()
            return
        }

        guard let _ = subject.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 1)) as? LaunchTableViewCell else {
            XCTFail()
            return
        }

        let delegate: MockDashboardTableViewSelectionDelegate = MockDashboardTableViewSelectionDelegate()
        subject.selectionDelegate = delegate
        subject.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 1))
        XCTAssertTrue(delegate.didSelectCalled)
    }
}

extension DashboardTableViewDataSourceTests {
    var mockCompany: Company {
        return Company(name: "name",
                       founder: "founder",
                       foundedYear: 2020,
                       employees: 10,
                       launchSites: 20,
                       valuation: 2000)
    }

    func mockLaunch(timestamp: TimeInterval = 100, success: Bool = true) -> Launch {
        return Launch(name: "name",
                      timestamp: timestamp,
                      links: Links(patch: nil,
                                   webcast: "https://www.spacex.com",
                                   article: "https://www.spacex.com",
                                   wikipedia: "https://www.spacex.com"),
                      rocketID: "identifier",
                      success: success)
    }
}
