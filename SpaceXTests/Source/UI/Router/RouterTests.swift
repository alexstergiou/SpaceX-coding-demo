//
//  RouterTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import UIKit
import XCTest

@testable import SpaceX

final class TestNavigationController: UINavigationController {

    var pushCalled: Bool = false
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushCalled = true
    }

    var presentCalled: Bool = false
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentCalled = true
    }

    var dismissCalled: Bool = false
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissCalled = true
    }
}

final class RouterTests: XCTestCase {
    func testRouter() {
        let navigationController: TestNavigationController = TestNavigationController()
        let subject: Router = Router(navigationController: navigationController)

        XCTAssertTrue(subject.navigationController.navigationBar.prefersLargeTitles)

        subject.push(UIViewController(), animated: false)
        XCTAssertTrue(navigationController.pushCalled)

        subject.present(UIViewController(), animated: false, completion: nil)
        XCTAssertTrue(navigationController.presentCalled)

        subject.dismiss(animated: false)
        XCTAssertTrue(navigationController.dismissCalled)
    }
}
