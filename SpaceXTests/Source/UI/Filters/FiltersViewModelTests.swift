//
//  FiltersViewModelTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 01/05/2021.
//

import XCTest

@testable import SpaceX

final class FiltersViewModelTests: XCTestCase {

    var filtersManager: MockFiltersManager!
    var subject: FiltersViewModel!

    override func setUpWithError() throws {
        filtersManager = MockFiltersManager()
        subject = FiltersViewModel(filtersManager: filtersManager)
    }

    override func tearDownWithError() throws {
        subject = nil
        filtersManager = nil
    }

    func testFunctions() {
        XCTAssertEqual(subject.title, L.Dashboard.filters)

        let tableView: UITableView = UITableView()
        subject.setup(tableView: tableView)
        XCTAssertNotNil(tableView.dataSource)

        let delegate: TestActionDelegate = TestActionDelegate()
        subject.actionDelegate = delegate
        subject.doneBarButtonItemTapped()
        XCTAssertTrue(delegate.didReceiveCalled)
        guard let action = delegate.action as? FiltersViewModel.CoordinatorAction else {
            XCTFail()
            return
        }
        switch action {
        case .dismiss:
            break
        }

        subject.filtersChanged()
        XCTAssertTrue(filtersManager.filtersUpdatedCalled)
    }
}
