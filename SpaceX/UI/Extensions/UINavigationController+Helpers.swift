//
//  UINavigationController+Helpers.swift
//  SpaceX
//
//  Created by Alex Stergiou on 30/04/2021.
//

import UIKit

extension UINavigationController {
    var defaultSetup: UINavigationController {

        navigationBar.prefersLargeTitles = true

        return self
    }
}
