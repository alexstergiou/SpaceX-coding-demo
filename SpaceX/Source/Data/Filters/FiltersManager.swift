//
//  FiltersManager.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import Foundation

@objc protocol FilterOperationsResponder: AnyObject {
    @objc optional func didUpdateFilters()
}

protocol FiltersManagerProtocol: AnyObject {
    var allFilters: [Filter] { get }
    func update(with launches: [Launch]) -> [Launch]
    func validate(launches: [Launch]) -> [Launch]

    func add(responder: FilterOperationsResponder)
    func remove(responder: FilterOperationsResponder)

    func filtersUpdated()
    @discardableResult func saveFilters() -> Bool
}

final class FiltersManager: FiltersManagerProtocol {
    fileprivate(set) var filters: [Filter] = []

    fileprivate(set) var responders = NSHashTable<FilterOperationsResponder>.weakObjects()
    let defaults: DefaultsType

    init(defaults: DefaultsType) {
        self.defaults = defaults
        self.filters = loadFilters()
    }

    var allFilters: [Filter] {
        return filters
    }

    func update(with launches: [Launch]) -> [Launch] {
        filters.forEach ({ $0.update(launches: launches) })
        return validate(launches: launches)
    }

    func validate(launches: [Launch]) -> [Launch] {
        var filteredLaunches: [Launch] = launches
        filters.forEach { filter in
            filteredLaunches = filter.validate(launches: filteredLaunches)
        }
        return filteredLaunches
    }

    func add(responder: FilterOperationsResponder) {
        responders.add(responder)
    }

    func remove(responder: FilterOperationsResponder) {
        responders.remove(responder)
    }

    func filtersUpdated() {
        responders.allObjects.forEach { responder in
            responder.didUpdateFilters?()
        }
        saveFilters()
    }
    
    @discardableResult func saveFilters() -> Bool {
        for filter in filters {
            var value: Bool = true
            switch filter.type {
            case .duration:
                value = saveDurationFilter(filter: filter)
            case .launchSuccess:
                value = saveLaunchSuccessFilter(filter: filter)
            case .orderAscending:
                value = saveOrderAscendingFilter(filter: filter)
            }
            if value == false {
                return false
            }
        }
        return true
    }
}

extension FiltersManager {
    func loadFilters() -> [Filter] {
        return loadStoredFilters() ?? defaultFilters
    }

    var expectedFiltersCount: Int {
        return defaultFilterTypes.count
    }

    var defaultFilterTypes: [FilterType] {
        return [.duration, .launchSuccess, .orderAscending]
    }

    var defaultFilters: [Filter] {
        return defaultFilterTypes.map { defaultFilter(with: $0) }
    }

    func defaultFilter(with type: FilterType) -> Filter {
        switch type {
        case .duration:
            return DurationFilter()
        case .launchSuccess:
            return LaunchSuccessFilter()
        case .orderAscending:
            return OrderAscendingFilter()
        }
    }

    var storedDurationFilter: DurationFilter? {
        guard let data = defaults.data(FilterType.duration.key) else { return nil }
        let filter = try? JSONDecoder().decode(DurationFilter.self, from: data)
        return filter
    }

    var storedLaunchSuccessFilter: LaunchSuccessFilter? {
        guard let data = defaults.data(FilterType.launchSuccess.key) else { return nil }
        let filter = try? JSONDecoder().decode(LaunchSuccessFilter.self, from: data)
        return filter
    }

    var storedOrderAscendingFilter: OrderAscendingFilter? {
        guard let data = defaults.data(FilterType.orderAscending.key) else { return nil }
        let filter = try? JSONDecoder().decode(OrderAscendingFilter.self, from: data)
        return filter
    }

    func loadStoredFilters() -> [Filter]? {
        let filters = defaultFilterTypes.compactMap { storedFilter(with: $0) }
        guard filters.count == expectedFiltersCount else {
            return nil
        }
        return filters
    }

    func storedFilter(with type: FilterType) -> Filter? {
        switch type {
        case .duration:
            return storedDurationFilter
        case .launchSuccess:
            return storedLaunchSuccessFilter
        case .orderAscending:
            return storedOrderAscendingFilter
        }
    }

    func saveDurationFilter(filter: Filter) -> Bool {
        guard let item = filter as? DurationFilter else {
            return false
        }

        do {
            let data = try JSONEncoder().encode(item)
            defaults[filter.type.key] = data
            return true
        } catch {
            return false
        }
    }

    func saveLaunchSuccessFilter(filter: Filter) -> Bool {
        guard let item = filter as? LaunchSuccessFilter else {
            return false
        }

        do {
            let data = try JSONEncoder().encode(item)
            defaults[filter.type.key] = data
            return true
        } catch {
            return false
        }
    }

    func saveOrderAscendingFilter(filter: Filter) -> Bool {
        guard let item = filter as? OrderAscendingFilter else {
            return false
        }

        do {
            let data = try JSONEncoder().encode(item)
            defaults[filter.type.key] = data
            return true
        } catch {
            return false
        }
    }
}
