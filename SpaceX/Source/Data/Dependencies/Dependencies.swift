//
//  Dependencies.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import Foundation

final class Dependencies {
    let services: Services
    let filtersManager: FiltersManagerProtocol
    let defaults: DefaultsType

    init(services: Services,
         filtersManager: FiltersManagerProtocol,
         defaults: DefaultsType) {
        self.services = services
        self.filtersManager = filtersManager
        self.defaults = defaults
    }
}

final class Services {
    let client: NetworkClientProtocol
    let companyService: CompanyServiceProtocol
    let launchesService: LaunchesServiceProtocol
    let imageService: ImageServiceProtocol
    let rocketService: RocketServiceProtocol

    init(client: NetworkClientProtocol,
         companyService: CompanyServiceProtocol,
         launchesService: LaunchesServiceProtocol,
         imageService: ImageServiceProtocol,
         rocketService: RocketServiceProtocol) {
        self.client = client
        self.companyService = companyService
        self.launchesService = launchesService
        self.imageService = imageService
        self.rocketService = rocketService
    }
}

extension Dependencies {
    static var live: Dependencies {
        let client: NetworkClient = NetworkClient(session: URLSession.shared)
        let companyService: CompanyService = CompanyService(client: client)
        let launchesService: LaunchesService = LaunchesService(client: client)
        let imageCache: ImageCache = ImageCache()
        let imageService: ImageService = ImageService(client: client, cache: imageCache)
        let rocketService: RocketService = RocketService(client: client)
        let defaults: DefaultsType = Defaults
        let filtersManager: FiltersManager = FiltersManager(defaults: defaults)

        let services: Services = Services(client: client,
                                          companyService: companyService,
                                          launchesService: launchesService,
                                          imageService: imageService,
                                          rocketService: rocketService)

        return Dependencies(services: services,
                            filtersManager: filtersManager,
                            defaults: defaults)
    }
}
