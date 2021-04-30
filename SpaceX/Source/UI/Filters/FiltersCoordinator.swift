//
//  FiltersCoordinator.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import UIKit

final class FiltersCoordinator: Coordinator {
    var parent: Coordinator?
    let router: Routable
    var children: [Coordinator] = []
    let dependencies: Dependencies

    init(router: Routable = Router(), dependencies: Dependencies) {
        self.router = router
        self.dependencies = dependencies
    }

    func start() {
        let viewModel: FiltersViewModel = FiltersViewModel(filtersManager: dependencies.filtersManager)
        viewModel.actionDelegate = self

        let viewController: FiltersViewController = FiltersViewController(viewModel: viewModel)
        
        router.push(viewController, animated: true)
    }

}

extension FiltersCoordinator: ActionDelegate {
    func didReceive(action: DelegateAction) {
        if let action = action as? FiltersViewModel.CoordinatorAction {
            switch action {
            case .dismiss:
                router.dismiss(animated: true)
                parent?.removeChildCoordinator(self)
            }
        }
    }
}
