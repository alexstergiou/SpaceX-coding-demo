//
//  FiltersViewControllerTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 01/05/2021.
//

import XCTest

@testable import SpaceX

final class MockFiltersViewModelProtocol: FiltersViewModelProtocol {
    var title: String = "Title"

    var setupCalled: Bool = false
    func setup(tableView: UITableView) {
        setupCalled = true
    }

    var doneBarButtonItemTappedCalled: Bool = false
    func doneBarButtonItemTapped() {
        doneBarButtonItemTappedCalled = true
    }
}

final class FiltersViewControllerTests: XCTestCase {

    var subject: FiltersViewController!
    var viewModel: MockFiltersViewModelProtocol!

    override func setUpWithError() throws {
        viewModel = MockFiltersViewModelProtocol()
        subject = FiltersViewController(viewModel: viewModel)
    }

    override func tearDownWithError() throws {
        subject = nil
        viewModel = nil
    }

    func testSetup() {
        subject.loadAndAppear()
        XCTAssertTrue(viewModel.setupCalled)
        XCTAssertEqual(subject.title, "Title")
        XCTAssertEqual(subject.navigationItem.largeTitleDisplayMode, .always)
        XCTAssertNotNil(subject.navigationItem.rightBarButtonItem)
    }

    func testAction() {
        subject.doneBarButtonItemTapped()
        XCTAssertTrue(viewModel.doneBarButtonItemTappedCalled)
    }
}
