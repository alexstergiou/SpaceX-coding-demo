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
    let linkAlertProvider: LinkAlertProvider

    init(router: Routable,
         dependencies: Dependencies,
         linkAlertProvider: LinkAlertProvider = LinkAlertProvider()) {
        self.router = router
        self.dependencies = dependencies
        self.linkAlertProvider = linkAlertProvider
    }

    func start() {
        let dataSource: DashboardTableViewDataSource = DashboardTableViewDataSource(services: dependencies.services)
        let viewModel: DashboardViewModel = DashboardViewModel(companyService: dependencies.services.companyService,
                                                               launchesService: dependencies.services.launchesService,
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
            case .actions(let item):
                showActions(item: item)
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

    func showActions(item: DashboardItem) {
        guard let controller = linkAlertProvider.alertController(for: item) else { return }

        router.present(controller, animated: true, completion: nil)
    }
}
