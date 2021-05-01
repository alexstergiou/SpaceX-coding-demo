//
//  LinkAlertProviderTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import XCTest

@testable import SpaceX

final class TestLaunchItem: LaunchItem {
    let type: DashboardItemType = .launch

    let launch: Launch
    init(launch: Launch) {
        self.launch = launch
    }
}

final class MockApplication: Application {
    var canOpenURLValue: Bool = false
    var canOpenURLCalled: Bool = false
    func canOpenURL(_ url: URL) -> Bool {
        canOpenURLCalled = true
        return canOpenURLValue
    }

    var openURLCalled: Bool = false
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)?) {
        openURLCalled = true
    }
}

final class TestCompanyDashboardItem: DashboardItem {
    let type: DashboardItemType = .company
}

final class LinkAlertProviderTests: XCTestCase {
    func testAlertController() {
        let application: MockApplication = MockApplication()
        let subject: LinkAlertProvider = LinkAlertProvider(application: application)
        var controller: UIAlertController? = subject.alertController(for: TestCompanyDashboardItem())
        XCTAssertNil(controller)

        var item: LaunchItem = self.testLaunchItem(hasWebcast: true, hasArticle: false, hasWikipedia: false)
        controller = subject.alertController(for: item)
        XCTAssertEqual(controller?.actions.count, 2)

        item = self.testLaunchItem(hasWebcast: true, hasArticle: true, hasWikipedia: false)
        controller = subject.alertController(for: item)
        XCTAssertEqual(controller?.actions.count, 3)

        item = self.testLaunchItem(hasWebcast: true, hasArticle: true, hasWikipedia: true)
        controller = subject.alertController(for: item)
        XCTAssertEqual(controller?.actions.count, 4)

        subject.open(url: nil)
        XCTAssertFalse(application.canOpenURLCalled)
        XCTAssertFalse(application.openURLCalled)

        let url: URL = URL(string: "https://www.spacex.com")!
        subject.open(url: url)
        XCTAssertTrue(application.canOpenURLCalled)
        XCTAssertFalse(application.openURLCalled)

        application.canOpenURLValue = true
        subject.open(url: url)
        XCTAssertTrue(application.canOpenURLCalled)
        XCTAssertTrue(application.openURLCalled)
    }
}

extension LinkAlertProviderTests {
    func testLaunchItem(hasWebcast: Bool = true, hasArticle: Bool = true, hasWikipedia: Bool = true) -> TestLaunchItem {
        return TestLaunchItem(launch: testLaunch(hasWebcast: hasWebcast,
                                                 hasArticle: hasArticle,
                                                 hasWikipedia: hasWikipedia))
    }
    func testLaunch(hasWebcast: Bool = true, hasArticle: Bool = true, hasWikipedia: Bool = true) -> Launch {
        let webcast: String? = hasWebcast ? "https://www.spacex.com" : nil
        let article: String? = hasArticle ? "https://www.spacex.com" : nil
        let wiki: String? = hasWikipedia ? "https://www.spacex.com" : nil
        return Launch(name: "name",
                      timestamp: 100,
                      links: Links(patch: nil,
                                   webcast: webcast,
                                   article: article,
                                   wikipedia: wiki),
                      rocketID: "identifier",
                      success: true)
    }
}
