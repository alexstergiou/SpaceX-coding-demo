//
//  String+Helpers.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import Foundation

extension String {
    func format(_ arguments: CVarArg...) -> String {
        return String(format: self, arguments: arguments)
    }
}
