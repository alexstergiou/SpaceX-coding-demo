//
//  DashboardLaunchesSectionViewModel.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import UIKit

final class DashboardLaunchesSectionViewModel: DashboardSection {
    let title: String = L.Dashboard.launches
    let type: DashboardSectionType = .launches
    var items: [DashboardItem] = []
    let dateFormatter: DateFormatter

    let launchesService: LaunchesServiceProtocol
    let imageService: ImageServiceProtocol
    let rocketService: RocketServiceProtocol

    init(launchesService: LaunchesServiceProtocol,
         imageService: ImageServiceProtocol,
         rocketService: RocketServiceProtocol,
         dateFormatter: DateFormatter = DateFormatter()) {
        self.launchesService = launchesService
        self.imageService = imageService
        self.rocketService = rocketService
        self.dateFormatter = dateFormatter
        self.dateFormatter.dateFormat = DateFormat.dateTime.rawValue
    }

    var numberOfItems: Int {
        return items.count
    }

    func update(with launches: [Launch]) {
        items = launches.map { DashboardLaunchItemViewModel(launch: $0,
                                                            imageService: imageService,
                                                            rocketService: rocketService,
                                                            dateFormatter: dateFormatter) }
    }
}
