//
//  MockFiltersManager.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import Foundation

@testable import SpaceX

final class MockFiltersManager: FiltersManagerProtocol {
    var filters: [Filter] = []

    var allFilters: [Filter] {
        return filters
    }

    var updateCalled: Bool = false
    var updatedLaunchesToReturn: [Launch] = []
    func update(with launches: [Launch]) -> [Launch] {
        updateCalled = true
        return updatedLaunchesToReturn
    }

    var validateCalled: Bool = false
    var validatedLaunchesToReturn: [Launch] = []
    func validate(launches: [Launch]) -> [Launch] {
        validateCalled = true
        return validatedLaunchesToReturn
    }

    var addResponderCalled: Bool = false
    func add(responder: FilterOperationsResponder) {
        addResponderCalled = true
    }

    var removeResponderCalled: Bool = false
    func remove(responder: FilterOperationsResponder) {
        removeResponderCalled = true
    }

    var filtersUpdatedCalled: Bool = false
    func filtersUpdated() {
        filtersUpdatedCalled = true
    }

    var saveSuccess: Bool = false
    func saveFilters() -> Bool {
        return saveSuccess
    }


}
