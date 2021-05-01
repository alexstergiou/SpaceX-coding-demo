//
//  MockRouter.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import UIKit

@testable import SpaceX

final class MockRouter: Routable {
    var navigationController: UINavigationController = UINavigationController()

    var pushCalled: Bool = false
    var pushedViewController: UIViewController?
    func push(_ controller: UIViewController, animated: Bool) {
        pushedViewController = controller
        pushCalled = true
    }

    var presentCalled: Bool = false
    var presentedViewController: UIViewController?
    func present(_ controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        presentedViewController = controller
        presentCalled = true
    }

    var dismissCalled: Bool = false
    func dismiss(animated: Bool) {
        dismissCalled = true
    }
}
