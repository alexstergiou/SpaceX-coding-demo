//
//  DashboardCoordinator.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import UIKit

final class DashboardCoordinator: Coordinator {
    var parent: Coordinator?
    let router: Routable
    var children: [Coordinator] = []
    let dependencies: Dependencies

    init(router: Routable, dependencies: Dependencies) {
        self.router = router
        self.dependencies = dependencies
    }

    func start() {
        let dataSource: DashboardTableViewDataSource = DashboardTableViewDataSource(launchesSection: DashboardLaunchesSectionViewModel(launchesService: dependencies.launchesService, imageService: dependencies.imageService, rocketService: dependencies.rocketService))
        let viewModel: DashboardViewModel = DashboardViewModel(companyService: dependencies.companyService,
                                                               launchesService: dependencies.launchesService,
                                                               dataSource: dataSource,
                                                               filtersManager: dependencies.filtersManager)
        let viewController: DashboardViewController = DashboardViewController(viewModel: viewModel)
        viewModel.responder = viewController
        viewModel.actionDelegate = self
        
        router.push(viewController, animated: true)
    }
}

extension DashboardCoordinator: ActionDelegate {
    func didReceive(action: DelegateAction) {
        if let dashboardAction = action as? DashboardViewModel.CoordinatorAction {
            switch dashboardAction {
            case .filters:
                showFilters()
            }
        }
    }
}

extension DashboardCoordinator {
    func showFilters() {
        let coordinator: FiltersCoordinator = FiltersCoordinator(dependencies: dependencies)
        coordinator.start()

        addChildCoordinator(coordinator)

        router.present(coordinator.router.navigationController, animated: true, completion: nil)
    }
}
