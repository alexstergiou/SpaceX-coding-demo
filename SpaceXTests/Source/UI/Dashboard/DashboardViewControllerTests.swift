//
//  DashboardViewControllerTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import XCTest

@testable import SpaceX

final class DashboardViewControllerTests: XCTestCase {

    var viewModel: MockDashboardViewModel!
    var subject: DashboardViewController!
    override func setUpWithError() throws {
        viewModel = MockDashboardViewModel()
        subject = DashboardViewController(viewModel: viewModel)
    }

    override func tearDownWithError() throws {
        subject = nil
        viewModel = nil
    }

    func testSetup() {
        subject.loadAndAppear()
        XCTAssertTrue(viewModel.setupCalled)
        XCTAssertTrue(viewModel.fetchDataCalled)
        XCTAssertEqual(subject.title, "Title")
    }

    func testBarButtonItems() {
        subject.setupBarButtonItems()
        XCTAssertNotNil(subject.navigationItem.rightBarButtonItem)
        XCTAssertEqual(subject.navigationItem.largeTitleDisplayMode, .always)
    }

    func testDidFetchLaunches() {
        subject.didFetchLaunches()
        XCTAssertNotNil(subject.navigationItem.rightBarButtonItem)
        XCTAssertEqual(subject.navigationItem.largeTitleDisplayMode, .always)
    }

    func testFilterButtonTapped() {
        subject.filterButtonTapped()
        XCTAssertTrue(viewModel.filtersButtonTappedCalled)
    }
}

extension UIViewController {
    func loadAndAppear() {
        loadViewIfNeeded()
        viewDidLoad()
        viewWillAppear(false)
        viewDidAppear(false)
    }
}
