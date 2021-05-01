//
//  FiltersTableViewDataSourceTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 01/05/2021.
//

import XCTest

@testable import SpaceX

final class MockFiltersTableViewDataSourceResponder: FiltersTableViewDataSourceResponder {

    var filtersChangedCalled: Bool = false
    func filtersChanged() {
        filtersChangedCalled = true
    }
}

final class FiltersTableViewDataSourceTests: XCTestCase {

    var filtersManager: MockFiltersManager!
    var subject: FiltersTableViewDataSource!
    var dateFormatter: DateFormatter!

    override func setUpWithError() throws {
        filtersManager = MockFiltersManager()
        dateFormatter = DateFormatter()
        subject = FiltersTableViewDataSource(filtersManager: filtersManager,
                                             dateFormatter: dateFormatter)
    }

    override func tearDownWithError() throws {
        subject = nil
        filtersManager = nil
        dateFormatter = nil
    }

    func testSetup() {
        let tableView: UITableView = UITableView()
        subject.setup(tableView: tableView)

        XCTAssertNotNil(tableView.dataSource)
        XCTAssertNotNil(tableView.tableFooterView)
    }

    func testTableViewMethods() {
        let tableView: UITableView = UITableView()
        subject.setup(tableView: tableView)

        XCTAssertEqual(subject.tableView(tableView, numberOfRowsInSection: 0), 0)

        filtersManager.filters = [DurationFilter(), LaunchSuccessFilter()]

        subject = FiltersTableViewDataSource(filtersManager: filtersManager,
                                             dateFormatter: dateFormatter)
        subject.setup(tableView: tableView)

        XCTAssertEqual(subject.tableView(tableView, numberOfRowsInSection: 0), 2)

        guard let durationCell = subject.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? StartEndDateTableViewCell else {
            XCTFail()
            return
        }

        XCTAssertNotNil(durationCell.titleLabel.text)

        guard let switchCell = subject.tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 0)) as? TitleSwitchTableViewCell else {
            XCTFail()
            return
        }

        XCTAssertNotNil(switchCell.titleLabel.text)
    }

    func testDateMethods() {
        let date1: Date = Date.with(year: 2021)
        XCTAssertEqual(subject.startText(date: date1), "Start: 2021")

        let date2: Date = Date.with(year: 2022)
        XCTAssertEqual(subject.endText(date: date2), "End: 2022")
    }

    func testResponder() {
        let responder: MockFiltersTableViewDataSourceResponder = MockFiltersTableViewDataSourceResponder()
        subject.responder = responder
        subject.valueChanged()
        XCTAssertTrue(responder.filtersChangedCalled)
    }
}
