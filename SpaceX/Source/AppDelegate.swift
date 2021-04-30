//
//  AppDelegate.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dashboardCoordinator: DashboardCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setupWindow()

        return true
    }
}

extension AppDelegate {
    func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)

        let router: Router = Router()
        dashboardCoordinator = DashboardCoordinator(router: router, dependencies: Dependencies.live)
        dashboardCoordinator?.start()
        
        window?.rootViewController = router.navigationController
        window?.makeKeyAndVisible()
    }
}
