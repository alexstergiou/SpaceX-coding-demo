//
//  Coordinator.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import UIKit

protocol Coordinator: AnyObject {
    var parent: Coordinator? { get set }
    var router: Routable { get }
    var children: [Coordinator] { get set }

    func start()
    func removeChildCoordinator(_ coordinator: Coordinator)
}

extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {
        coordinator.parent = self
        children.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: Coordinator) {
        children = children.filter { $0 !== coordinator }
    }
}

protocol DelegateAction {}

protocol ActionDelegate: AnyObject {
    func didReceive(action: DelegateAction)
}
