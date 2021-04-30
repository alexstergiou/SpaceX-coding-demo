//
//  LinkAlertProvider.swift
//  SpaceX
//
//  Created by Alex Stergiou on 30/04/2021.
//

import UIKit

final class LinkAlertProvider {
    func alertController(for item: DashboardItem) -> UIAlertController? {
        guard let launchItem = item as? LaunchItem else { return nil }

        var actions: [UIAlertAction] = []

        let links: Links = launchItem.launch.links
        if let urlString = links.webcast {
            actions.append(UIAlertAction(title: L.Dashboard.videos, style: .default, handler: { [weak self] _ in
                self?.open(url: URL(string: urlString))
            }))
        }

        if let urlString = links.article {
            actions.append(UIAlertAction(title: L.Dashboard.article, style: .default, handler: { [weak self] _ in
                self?.open(url: URL(string: urlString))
            }))
        }

        if let urlString = links.wikipedia {
            actions.append(UIAlertAction(title: L.Dashboard.wiki, style: .default, handler: { [weak self] _ in
                self?.open(url: URL(string: urlString))
            }))
        }

        let style: UIAlertController.Style = actions.count > 0 ? .actionSheet : .alert
        let message: String? = style == .alert ? L.Dashboard.noLinks : nil

        actions.append(UIAlertAction(title: L.Dashboard.cancel, style: .cancel, handler: nil))

        let controller: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: style)

        actions.forEach { action in
            controller.addAction(action)
        }

        return controller
    }

    func open(url: URL?) {
        guard let url = url else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
