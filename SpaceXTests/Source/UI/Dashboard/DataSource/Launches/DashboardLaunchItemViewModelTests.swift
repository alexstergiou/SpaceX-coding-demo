//
//  DashboardLaunchItemViewModelTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import XCTest

@testable import SpaceX

final class DashboardLaunchItemViewModelTests: XCTestCase {

    var launch: Launch!
    var dependenciesHelper: DependenciesHelper!
    var subject: DashboardLaunchItemViewModel!
    var dateFormatter: DateFormatter!

    override func setUpWithError() throws {
        launch = mockLaunch()
        dependenciesHelper = DependenciesHelper()
        dateFormatter = DateFormatter()
        subject = DashboardLaunchItemViewModel(launch: launch,
                                               imageService: dependenciesHelper.mockImageService,
                                               rocketService: dependenciesHelper.mockRocketService,
                                               dateFormatter: dateFormatter)

    }

    override func tearDownWithError() throws {
        subject = nil
        dependenciesHelper = nil
        dateFormatter = nil
    }

    func testProperties() {
        XCTAssertEqual(subject.name, "name")
        XCTAssertEqual(subject.date.timeIntervalSince1970, 100)

        XCTAssertNil(subject.rocketDescription)
        launch.rocket = Rocket(name: "rocket name", type: "type", description: "desc")
        XCTAssertEqual(subject.rocketDescription, "rocket name - type")

        var days: Double = 3
        var interval: TimeInterval = 24 * 60 * 60 * days
        launch = mockLaunch(timestamp: Date().timeIntervalSince1970 - interval)

        subject = DashboardLaunchItemViewModel(launch: launch,
                                               imageService: dependenciesHelper.mockImageService,
                                               rocketService: dependenciesHelper.mockRocketService,
                                               dateFormatter: dateFormatter)

        XCTAssertEqual(subject.daysSinceLaunch, 3)
        XCTAssertEqual(subject.daysSinceLaunchTitle, L.Dashboard.daysSinceNow)

        days = -3
        interval = 24 * 60 * 60 * days
        launch = mockLaunch(timestamp: Date().timeIntervalSince1970 - interval)

        subject = DashboardLaunchItemViewModel(launch: launch,
                                               imageService: dependenciesHelper.mockImageService,
                                               rocketService: dependenciesHelper.mockRocketService,
                                               dateFormatter: dateFormatter)

        XCTAssertEqual(subject.daysSinceLaunch, -3)
        XCTAssertEqual(subject.daysSinceLaunchTitle, L.Dashboard.daysFromNow)

        launch = mockLaunch(success: false)
        subject = DashboardLaunchItemViewModel(launch: launch,
                                               imageService: dependenciesHelper.mockImageService,
                                               rocketService: dependenciesHelper.mockRocketService,
                                               dateFormatter: dateFormatter)

        var image: UIImage = UIImage(named: "cross")!
        XCTAssertEqual(image.pngData()?.count, subject.outcomeImage?.pngData()?.count)

        guard let color1 = subject.outcomeImageColor else {
            XCTFail()
            return
        }
        XCTAssertTrue(color1.isEqual(UIColor.red))

        launch = mockLaunch(success: true)
        subject = DashboardLaunchItemViewModel(launch: launch,
                                               imageService: dependenciesHelper.mockImageService,
                                               rocketService: dependenciesHelper.mockRocketService,
                                               dateFormatter: dateFormatter)

        image = UIImage(named: "checkmark")!
        XCTAssertEqual(image.pngData()?.count, subject.outcomeImage?.pngData()?.count)

        guard let color2 = subject.outcomeImageColor else {
            XCTFail()
            return
        }
        XCTAssertTrue(color2.isEqual(UIColor.success))
    }
}

extension DashboardLaunchItemViewModelTests {
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
