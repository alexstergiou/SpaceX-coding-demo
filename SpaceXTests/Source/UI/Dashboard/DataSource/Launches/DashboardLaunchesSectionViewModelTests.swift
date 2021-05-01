//
//  DashboardLaunchesSectionViewModelTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import XCTest

@testable import SpaceX

final class DashboardLaunchesSectionViewModelTests: XCTestCase {

    func testUpdate() {
        let dependenciesHelper: DependenciesHelper = DependenciesHelper()
        let subject: DashboardLaunchesSectionViewModel = DashboardLaunchesSectionViewModel(launchesService: dependenciesHelper.mockLauchesService,
                                                                                           imageService: dependenciesHelper.mockImageService,
                                                                                           rocketService: dependenciesHelper.mockRocketService)
        XCTAssertEqual(subject.dateFormatter.dateFormat, DateFormat.dateTime.rawValue)
        subject.update(with: mockLaunches)
        XCTAssertEqual(subject.numberOfItems, 1)
    }
}

extension DashboardLaunchesSectionViewModelTests {
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
