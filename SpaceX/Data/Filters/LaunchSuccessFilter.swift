//
//  LaunchSuccessFilter.swift
//  SpaceX
//
//  Created by Alex Stergiou on 30/04/2021.
//

import Foundation

protocol BooleanItem {
    var value: Bool { get set }
    var title: String { get }
}

final class LaunchSuccessFilter: Filter, BooleanItem {
    let type: FilterType
    var value: Bool = false

    init(type: FilterType = .launchSuccess) {
        self.type = type
    }

    var title: String {
        return NSLocalizedString("Show only successful", comment: "")
    }

    func validate(launch: Launch) -> Bool {
        guard value == true else { return true }
        guard let success = launch.success else { return false }
        return success
    }

    func validate(launches: [Launch]) -> [Launch] {
        return launches.filter { validate(launch: $0) }
    }
}
