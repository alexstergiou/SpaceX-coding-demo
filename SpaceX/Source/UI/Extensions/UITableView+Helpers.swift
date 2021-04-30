//
//  UITableView+Extensions.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import UIKit

extension UITableView {
    func register(cellClass: AnyClass) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass.self))
    }

    func reload(section: Int) {
        beginUpdates()
        reloadSections(IndexSet(integer: section), with: .automatic)
        endUpdates()
    }
}

extension UITableViewCell {
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
}
