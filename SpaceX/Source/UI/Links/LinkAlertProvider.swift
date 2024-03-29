//
//  LinkAlertProvider.swift
//  SpaceX
//
//  Created by Alex Stergiou on 30/04/2021.
//

import UIKit

protocol Application: AnyObject {
    func canOpenURL(_ url: URL) -> Bool
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)?)
}

extension UIApplication: Application {}

protocol LinkAlertProviderProtocol {
    func alertController(for item: DashboardItem) -> UIAlertController?
    func open(url: URL?)
}

final class LinkAlertProvider: LinkAlertProviderProtocol {
    let application: Application
    init(application: Application = UIApplication.shared) {
        self.application = application
    }

    func alertController(for item: DashboardItem) -> UIAlertController? {
        guard let launchItem = item as? LaunchItem else { return nil }

        var actions: [UIAlertAction] = []

        let links: Links = launchItem.launch.links

        if let action = webcastAction(links: links) {
            actions.append(action)
        }

        if let action = articleAction(links: links) {
            actions.append(action)
        }

        if let action = wikiAction(links: links) {
            actions.append(action)
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
        guard application.canOpenURL(url) else { return }
        application.open(url, options: [:], completionHandler: nil)
    }
}

extension LinkAlertProvider {
    func webcastAction(links: Links) -> UIAlertAction? {
        return action(title: L.Dashboard.videos, urlString: links.webcast)
    }

    func articleAction(links: Links) -> UIAlertAction? {
        return action(title: L.Dashboard.article, urlString: links.article)
    }

    func wikiAction(links: Links) -> UIAlertAction? {
        return action(title: L.Dashboard.wiki, urlString: links.wikipedia)
    }

    func action(title: String, urlString: String?) -> UIAlertAction? {
        if let urlString = urlString {
            return UIAlertAction(title: title, style: .default, handler: { [weak self] _ in
                self?.open(url: URL(string: urlString))
            })
        }
        return nil
    }
}
