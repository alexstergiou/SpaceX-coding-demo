//
//  Router.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import UIKit

protocol Routable {
    var navigationController: UINavigationController { get }

    func push(_ controller: UIViewController, animated: Bool)
    func present(_ controller: UIViewController, animated: Bool, completion: (() -> Void)?)
    func dismiss(animated: Bool)
}

final class Router: Routable {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController.defaultSetup
    }

    func push(_ controller: UIViewController, animated: Bool) {
        navigationController.pushViewController(controller, animated: animated)
    }

    func present(_ controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        navigationController.present(controller, animated: animated, completion: completion)
    }

    func dismiss(animated: Bool) {
        navigationController.dismiss(animated: animated, completion: nil)
    }
}
