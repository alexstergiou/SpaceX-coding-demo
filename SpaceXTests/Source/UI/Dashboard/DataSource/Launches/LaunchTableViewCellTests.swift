//
//  LaunchTableViewCellTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import XCTest

@testable import SpaceX

final class LaunchTableViewCellTests: XCTestCase {

    var subject: LaunchTableViewCell!
    var dependenciesHelper: DependenciesHelper!

    override func setUpWithError() throws {
        dependenciesHelper = DependenciesHelper()
        subject = LaunchTableViewCell(style: .default, reuseIdentifier: LaunchTableViewCell.reuseIdentifier())
    }

    override func tearDownWithError() throws {
        subject = nil
        dependenciesHelper = nil
    }

    func testUpdate() {
        let viewModel: MockDashboardLaunchItemViewModel = MockDashboardLaunchItemViewModel(launch: mockLaunch())
        subject.update(with: viewModel)

        XCTAssertNotNil(subject.viewModel)

        XCTAssertTrue(viewModel.fetchImageCalled)
        XCTAssertTrue(viewModel.fetchDetailsCalled)
        XCTAssertNil(subject.outcomeImageView.image)
        XCTAssertNotNil(subject.dateValueView.valueLabel.text)
        XCTAssertNotNil(subject.dateValueView.keyLabel.text)

        XCTAssertNotNil(subject.daysValueView.valueLabel.text)
        XCTAssertNotNil(subject.daysValueView.keyLabel.text)

        XCTAssertNotNil(subject.missionValueView.valueLabel.text)
        XCTAssertNotNil(subject.missionValueView.keyLabel.text)
    }

    func testReuse() {
        let viewModel: MockDashboardLaunchItemViewModel = MockDashboardLaunchItemViewModel(launch: mockLaunch())
        subject.update(with: viewModel)

        subject.prepareForReuse()

        XCTAssertTrue(viewModel.cancelCalled)
    }
}

extension LaunchTableViewCellTests {
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
