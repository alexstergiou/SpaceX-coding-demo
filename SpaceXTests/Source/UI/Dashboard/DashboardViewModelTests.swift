//
//  DashboardViewModelTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import XCTest

@testable import SpaceX

final class TestActionDelegate: ActionDelegate {

    var didReceiveCalled: Bool = false
    var action: DelegateAction?
    func didReceive(action: DelegateAction) {
        didReceiveCalled = true
        self.action = action
    }
}

final class TestDashboardViewModelResponder: DashboardViewModelResponder {

    var shouldReloadCalled: Bool = false
    var shouldReloadSection: Int? = nil
    func shouldReload(section: Int) {
        shouldReloadCalled = true
        shouldReloadSection = section
    }

    var didFetchLaunchesCalled: Bool = false
    func didFetchLaunches() {
        didFetchLaunchesCalled = true
    }
}

final class DashboardViewModelTests: XCTestCase {

    var mockDataSource: MockDashboardTableViewDataSource!
    var dependenciesHelper: DependenciesHelper!
    var subject: DashboardViewModel!

    override func setUpWithError() throws {
        mockDataSource = MockDashboardTableViewDataSource()
        dependenciesHelper = DependenciesHelper()
        subject = DashboardViewModel(companyService: dependenciesHelper.mockCompanyService,
                                     launchesService: dependenciesHelper.mockLauchesService,
                                     dataSource: mockDataSource,
                                     filtersManager: dependenciesHelper.mockFiltersManager)
    }

    override func tearDownWithError() throws {
        subject = nil
        mockDataSource = nil
        dependenciesHelper = nil
    }

    func testInit() {
        XCTAssertTrue(dependenciesHelper.mockFiltersManager.addResponderCalled)
    }

    func testFetchData() {
        subject.fetchData()

        XCTAssertTrue(dependenciesHelper.mockCompanyService.fetchCompanyInfoCalled)
        XCTAssertTrue(dependenciesHelper.mockLauchesService.fetchLaunchesCalled)
    }

    func testSetup() {
        subject.setup(tableView: UITableView())
        XCTAssertTrue(mockDataSource.setupCalled)
    }

    func testFiltersButtonTapped() {
        let delegate: TestActionDelegate = TestActionDelegate()
        subject.actionDelegate = delegate
        subject.filtersButtonTapped()
        XCTAssertTrue(delegate.didReceiveCalled)
        guard let action = delegate.action as? DashboardViewModel.CoordinatorAction else {
            XCTFail()
            return
        }
        switch action {
        case .actions:
            XCTFail()
        case .filters:
            break
        }
    }

    func testFetchCompanyInfo() {
        let responder: TestDashboardViewModelResponder = TestDashboardViewModelResponder()
        dependenciesHelper.mockCompanyService.company = self.mockCompany
        mockDataSource.updateCompanySection = 0
        subject.responder = responder

        subject.fetchCompanyInfo()

        eventually(timeout: 0.5) {
            XCTAssertTrue(self.mockDataSource.updateCompanyCalled)
            XCTAssertTrue(responder.shouldReloadCalled)
            XCTAssertEqual(responder.shouldReloadSection, 0)
        }
    }

    func testFetchCompanyInfoNoSection() {
        let responder: TestDashboardViewModelResponder = TestDashboardViewModelResponder()
        dependenciesHelper.mockCompanyService.company = self.mockCompany
        mockDataSource.updateCompanySection = nil
        subject.responder = responder

        subject.fetchCompanyInfo()

        eventually(timeout: 0.5) {
            XCTAssertTrue(self.mockDataSource.updateCompanyCalled)
            XCTAssertFalse(responder.shouldReloadCalled)
            XCTAssertNil(responder.shouldReloadSection)
        }
    }

    func testFetchLaunches() {
        let responder: TestDashboardViewModelResponder = TestDashboardViewModelResponder()
        dependenciesHelper.mockLauchesService.launches = mockLaunches
        mockDataSource.updateLaunchesSection = 1
        subject.responder = responder

        XCTAssertEqual(subject.launches.count, 0)

        subject.fetchLaunchInfo()

        eventually(timeout: 0.5) {
            XCTAssertEqual(self.subject.launches.count, 1)
            XCTAssertTrue(self.dependenciesHelper.mockFiltersManager.updateCalled)
            XCTAssertTrue(responder.didFetchLaunchesCalled)
            XCTAssertEqual(responder.shouldReloadSection, 1)
        }
    }

    func testDidUpdateFilters() {
        mockDataSource.updateLaunchesSection = 1
        let responder: TestDashboardViewModelResponder = TestDashboardViewModelResponder()
        subject.responder = responder
        subject.didUpdateFilters()

        XCTAssertTrue(responder.shouldReloadCalled)
    }

    func testDidSelectItem() {
        let item: TestCompanyDashboardItem = TestCompanyDashboardItem()
        let delegate: TestActionDelegate = TestActionDelegate()
        subject.actionDelegate = delegate
        subject.didSelect(item: item)

        XCTAssertTrue(delegate.didReceiveCalled)
        guard let action = delegate.action as? DashboardViewModel.CoordinatorAction else {
            XCTFail()
            return
        }
        switch action {
        case .actions:
            break
        case .filters:
            XCTFail()
        }
    }
}

extension DashboardViewModelTests {
    var mockCompanyData: Data {
        let encoder: JSONEncoder = JSONEncoder()
        return try! encoder.encode(mockCompany)
    }

    var mockCompany: Company {
        return Company(name: "name",
                       founder: "founder",
                       foundedYear: 2020,
                       employees: 10,
                       launchSites: 20,
                       valuation: 2000)
    }

    var mockLaunches: [Launch] {
        return [Launch(name: "name",
                       timestamp: 100,
                       links: Links(patch: nil,
                                    webcast: "https://www.spacex.com",
                                    article: "https://www.spacex.com",
                                    wikipedia: "https://www.spacex.com"),
                       rocketID: "identifier",
                       success: true)]
    }
}
