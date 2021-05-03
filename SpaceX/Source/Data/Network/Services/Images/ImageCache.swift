//
//  ImageCache.swift
//  SpaceX
//
//  Created by Alex Stergiou on 29/04/2021.
//

import UIKit

final class ImageResponse {
    let urlString: String
    let image: UIImage

    init(urlString: String, image: UIImage) {
        self.urlString = urlString
        self.image = image
    }
}

protocol ImageCacheProtocol {
    @discardableResult func add(image: UIImage, url: URL) -> ImageResponse
    func image(url: URL?) -> ImageResponse?
}

final class ImageCache: ImageCacheProtocol {
    var cache: [String: ImageResponse] = [:]

    func image(url: URL?) -> ImageResponse? {
        guard let url = url else { return nil }
        return cache[url.absoluteString]
    }

    @discardableResult func add(image: UIImage, url: URL) -> ImageResponse {
        let response: ImageResponse = ImageResponse(urlString: url.absoluteString, image: image)
        cache[url.absoluteString] = response
        return response
    }
}
