//
//  ImageCache.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import UIKit

protocol ImageCacheProtocol {
    func add(image: UIImage, url: URL)
    func image(url: URL?) -> UIImage?
}

final class ImageCache: ImageCacheProtocol {
    var cache: [String: UIImage] = [:]

    func image(url: URL?) -> UIImage? {
        guard let url = url else { return nil }
        return cache[url.absoluteString]
    }

    func add(image: UIImage, url: URL) {
        cache[url.absoluteString] = image
    }
}
