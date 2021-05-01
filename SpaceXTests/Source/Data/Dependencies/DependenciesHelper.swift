//
//  DependenciesHelper.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 29/04/2021.
//

import Foundation

@testable import SpaceX

final class DependenciesHelper {
    let mockClient: MockNetworkClient = MockNetworkClient()
    let mockCompanyService: MockCompanyService = MockCompanyService()
    let mockRocketService: MockRocketService = MockRocketService()
    let mockImageService: MockImageService = MockImageService()
    let mockImageCache: MockImageCache = MockImageCache()
    let mockLauchesService: MockLaunchesService = MockLaunchesService()
    let mockFiltersManager: MockFiltersManager = MockFiltersManager()
    let mockDefaults: MockDefaults = MockDefaults()
    let mockRouter: MockRouter = MockRouter()
    let mockLinkAlertProvider: MockLinkAlertProvider = MockLinkAlertProvider()
}

extension DependenciesHelper {
    var dependencies: Dependencies {
        let services: Services = Services(client: mockClient,
                                          companyService: mockCompanyService,
                                          launchesService: mockLauchesService,
                                          imageService: mockImageService,
                                          rocketService: mockRocketService)
        return Dependencies(services: services,
                            filtersManager: mockFiltersManager,
                            defaults: mockDefaults)
    }

    var services: Services {
        return Services(client: mockClient,
                        companyService: mockCompanyService,
                        launchesService: mockLauchesService,
                        imageService: mockImageService,
                        rocketService: mockRocketService)
    }
}
