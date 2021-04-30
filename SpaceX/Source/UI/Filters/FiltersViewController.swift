//
//  FiltersViewController.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import UIKit

final class FiltersViewController: UITableViewController {

    let viewModel: FiltersViewModelProtocol

    init(viewModel: FiltersViewModelProtocol) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.setup(tableView: tableView)

        setupNavigationBarItems()
    }
}

extension FiltersViewController {
    func setupNavigationBarItems() {
        title = viewModel.title

        navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBarButtonItemTapped))
    }

    @objc func doneBarButtonItemTapped() {
        viewModel.doneBarButtonItemTapped()
    }
}
