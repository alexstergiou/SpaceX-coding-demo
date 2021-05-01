//
//  ImageCacheTests.swift
//  SpaceXTests
//
//  Created by Alex Stergiou on 30/04/2021.
//

import XCTest

@testable import SpaceX

final class ImageCacheTests: XCTestCase {

    func testCache() {
        let subject: ImageCache = ImageCache()

        subject.add(image: mockImage, url: imageURL)
        
        XCTAssertEqual(subject.cache.count, 1)
        XCTAssertNil(subject.image(url: nil))
        XCTAssertNotNil(subject.image(url: imageURL))
    }
}

extension ImageCacheTests {
    var imageURL: URL {
        return URL(string: "https://api.spacexdata.com/v4")!
    }
    var mockImage: UIImage {
        return UIImage(named: "logo")!
    }
}
