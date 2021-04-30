//
//  Localizations.swift
//  SpaceX
//
//  Created by Alex Stergiou on 30/04/2021.
//

import Foundation

struct L {
    static var app: String { Bundle.localized(key: "spaceX") }

    struct Dashboard {
        static var filters: String { Bundle.localized(key: "filters") }
        static var mission: String { Bundle.localized(key: "mission") }
        static var dateTime: String { Bundle.localized(key: "dateTime") }
        static var rocket: String { Bundle.localized(key: "rocket") }
        static var daysFromNow: String { Bundle.localized(key: "daysFromNow") }
        static var daysSinceNow: String { Bundle.localized(key: "daysSinceNow") }
        static var launches: String { Bundle.localized(key: "launches") }
        static var cancel: String { Bundle.localized(key: "cancel") }
        static var videos: String { Bundle.localized(key: "videos") }
        static var article: String { Bundle.localized(key: "article") }
        static var wiki: String { Bundle.localized(key: "wiki") }
        static var noLinks: String { Bundle.localized(key: "noLinks") }

        struct Company {
            static var title: String { Bundle.localized(key: "dashboard.company.title") }
            static var description: String { Bundle.localized(key: "dashboard.company.description") }
        }
    }

    struct Filters {
        static var start: String { Bundle.localized(key: "start") }
        static var end: String { Bundle.localized(key: "end") }
        static var ascending: String { Bundle.localized(key: "ascending") }
        static var showSuccess: String { Bundle.localized(key: "showSuccess") }
        static var duration: String { Bundle.localized(key: "duration") }
    }
}

extension Bundle {
    static func localized(key: String) -> String {
        return NSLocalizedString(key, tableName: nil, bundle: Bundle.main, value: key, comment: "")
    }
}
