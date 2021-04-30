//
//  Dependencies.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import Foundation

final class Dependencies {
    let client: NetworkClientProtocol
    let companyService: CompanyServiceProtocol
    let launchesService: LaunchesServiceProtocol
    let imageService: ImageServiceProtocol
    let rocketService: RocketServiceProtocol
    let filtersManager: FiltersManagerProtocol

    init(client: NetworkClientProtocol,
         companyService: CompanyServiceProtocol,
         launchesService: LaunchesServiceProtocol,
         imageService: ImageService,
         rocketService: RocketServiceProtocol,
         filtersManager: FiltersManagerProtocol) {
        self.client = client
        self.companyService = companyService
        self.launchesService = launchesService
        self.imageService = imageService
        self.rocketService = rocketService
        self.filtersManager = filtersManager
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
        let filtersManager: FiltersManager = FiltersManager()

        return Dependencies(client: client,
                            companyService: companyService,
                            launchesService: launchesService,
                            imageService: imageService,
                            rocketService: rocketService,
                            filtersManager: filtersManager)
    }
}
