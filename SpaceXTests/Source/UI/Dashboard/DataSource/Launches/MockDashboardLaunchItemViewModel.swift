//
//  MockDashboardLaunchItemViewModelProtocol.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//
import XCTest

@testable import SpaceX

final class MockDashboardLaunchItemViewModel: DashboardLaunchItemViewModelProtocol {
    var name: String = "Launch Name"

    var daysSinceLaunch: Int = 2

    var daysSinceLaunchTitle: String = "2"

    var imageURL: URL?

    var rocketDescription: String?

    var formattedLaunchDate: String = ""

    var outcomeImage: UIImage?

    var outcomeImageColor: UIColor?

    var fetchImageCalled: Bool = false
    func fetchImage(completion: ImageServiceCompletion?) {
        fetchImageCalled = true
    }

    var fetchDetailsCalled: Bool = false
    func fetchDetails(completion: RocketDetailsCompletion?) {
        fetchDetailsCalled = true
    }

    var cancelCalled: Bool = false
    func cancel() {
        cancelCalled = true
    }

    var launch: Launch

    var type: DashboardItemType = .launch

    init(launch: Launch) {
        self.launch = launch
    }
}
