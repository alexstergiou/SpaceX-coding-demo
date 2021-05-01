//
//  MockLinkAlertProvider.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import UIKit

@testable import SpaceX

final class MockLinkAlertProvider: LinkAlertProviderProtocol {

    var controller: UIAlertController?

    var alertControllerCalled: Bool = false
    func alertController(for item: DashboardItem) -> UIAlertController? {
        alertControllerCalled = true
        return controller
    }

    var openURLCalled: Bool = false
    func open(url: URL?) {
        openURLCalled = true
    }
}
