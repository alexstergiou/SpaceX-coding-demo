//
//  FiltersManagerTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import XCTest

@testable import SpaceX

final class MockFilterOperationsResponder: FilterOperationsResponder {

    var didUpdateFiltersCalled: Bool = false
    @objc func didUpdateFilters() {
        didUpdateFiltersCalled = true
    }
}

final class FiltersManagerTests: XCTestCase {

    var dependenciesHelper: DependenciesHelper!
    var subject: FiltersManager!

    override func setUpWithError() throws {
        dependenciesHelper = DependenciesHelper()
        subject = FiltersManager(defaults: dependenciesHelper.mockDefaults)
    }

    override func tearDownWithError() throws {
        subject = nil
        dependenciesHelper = nil
    }

    func testAllFilters() {
        XCTAssertEqual(subject.allFilters.count, 3)
    }

    func testStoredFilters() {
        mockFiltersInDefaults()

        subject = FiltersManager(defaults: dependenciesHelper.mockDefaults)

        let filters: [Filter] = subject.allFilters

        guard let storedDurationFilter: DurationFilter = filters[0] as? DurationFilter else {
            XCTFail()
            return
        }
        guard let storedLaunchSuccessFilter: LaunchSuccessFilter = filters[1] as? LaunchSuccessFilter else {
            XCTFail()
            return
        }
        guard let storedOrderFilter: OrderAscendingFilter = filters[2] as? OrderAscendingFilter else {
            XCTFail()
            return
        }

        XCTAssertEqual(storedDurationFilter.startDate.timeIntervalSince1970, 100)
        XCTAssertEqual(storedLaunchSuccessFilter.value, true)
        XCTAssertEqual(storedOrderFilter.value, false)
    }

    func testStoringFilters() {
        let group: TestFilterGroup = TestFilterGroup(start: 100,
                                                     end: 500,
                                                     success: true,
                                                     ascending: false)

        XCTAssertTrue(subject.saveDurationFilter(filter: group.durationFilter))
        XCTAssertFalse(subject.saveDurationFilter(filter: group.launchSuccessFilter))
        XCTAssertFalse(subject.saveDurationFilter(filter: group.orderFilter))

        XCTAssertFalse(subject.saveLaunchSuccessFilter(filter: group.durationFilter))
        XCTAssertTrue(subject.saveLaunchSuccessFilter(filter: group.launchSuccessFilter))
        XCTAssertFalse(subject.saveLaunchSuccessFilter(filter: group.orderFilter))

        XCTAssertFalse(subject.saveOrderAscendingFilter(filter: group.durationFilter))
        XCTAssertFalse(subject.saveOrderAscendingFilter(filter: group.launchSuccessFilter))
        XCTAssertTrue(subject.saveOrderAscendingFilter(filter: group.orderFilter))

        XCTAssertEqual(dependenciesHelper.mockDefaults.values.count, 3)
    }

    func testResponders() {
        dependenciesHelper = DependenciesHelper()

        XCTAssertFalse(dependenciesHelper.mockDefaults.valueSetCalled)
        subject = FiltersManager(defaults: dependenciesHelper.mockDefaults)
        XCTAssertFalse(dependenciesHelper.mockDefaults.valueSetCalled)

        let responder: MockFilterOperationsResponder = MockFilterOperationsResponder()
        subject.add(responder: responder)
        XCTAssertEqual(subject.responders.count, 1)

        subject.saveFilters()
        XCTAssertTrue(dependenciesHelper.mockDefaults.valueSetCalled)

        subject.filtersUpdated()
        XCTAssertTrue(responder.didUpdateFiltersCalled)

        responder.didUpdateFiltersCalled = false
        subject.remove(responder: responder)
        subject.filtersUpdated()
        XCTAssertFalse(responder.didUpdateFiltersCalled)
    }

    func testUpdate() {
        let group: TestFilterGroup = mockFiltersInDefaults()

        group.durationFilter.didInitialSetup = true

        subject = FiltersManager(defaults: dependenciesHelper.mockDefaults)

        let launch1: Launch = testLaunch(timestamp: 50, success: true)
        let launch2: Launch = testLaunch(timestamp: 200, success: true)
        let launch3: Launch = testLaunch(timestamp: 300, success: true)
        let launch4: Launch = testLaunch(timestamp: 400, success: false)

        let launches: [Launch] = [launch1, launch2, launch3, launch4];
        let validatedLaunches: [Launch] = subject.update(with: launches)
        XCTAssertEqual(validatedLaunches.count, 3)
    }
}

extension FiltersManagerTests {
    @discardableResult func mockFiltersInDefaults(start: TimeInterval = 100, end: TimeInterval = 500, success: Bool = true, ascending: Bool = false) -> TestFilterGroup {
        let group: TestFilterGroup = TestFilterGroup(start: start,
                                                     end: end,
                                                     success: success,
                                                     ascending: ascending)

        let encoder: JSONEncoder = JSONEncoder()
        dependenciesHelper.mockDefaults.data[group.durationFilter.type.rawValue] = try? encoder.encode(group.durationFilter)
        dependenciesHelper.mockDefaults.data[group.launchSuccessFilter.type.rawValue] = try? encoder.encode(group.launchSuccessFilter)
        dependenciesHelper.mockDefaults.data[group.orderFilter.type.rawValue] = try? encoder.encode(group.orderFilter)

        return group
    }

    func testLaunch(timestamp: TimeInterval, success: Bool) -> Launch {
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

final class TestFilterGroup {
    let durationFilter: DurationFilter = DurationFilter()
    let launchSuccessFilter: LaunchSuccessFilter = LaunchSuccessFilter()
    let orderFilter: OrderAscendingFilter = OrderAscendingFilter()

    init(start: TimeInterval, end: TimeInterval, success: Bool, ascending: Bool) {
        durationFilter.startDate = Date(timeIntervalSince1970: start)
        durationFilter.endDate = Date(timeIntervalSince1970: end)
        launchSuccessFilter.value = success
        orderFilter.value = ascending
    }
}
