//
//  RemoteImage.swift
//  FuseCodeChallenge
//
//  Created by Felipe Oliveira on 12/13/22.
//

import UIKit

struct RemoteImage {
  static let shared = RemoteImage()
  
  private let cache = NSCache<NSString, UIImage>()
  private var session = URLSession.shared

  func load(url: URL) async throws -> UIImage? {
    if let cachedImage = cache.object(forKey: url.absoluteString as NSString) {
      return cachedImage
    }

    let (data, _) = try await session.data(from: url)

    guard
      let image = UIImage(data: data)
    else { return nil }

    cache.setObject(image, forKey: url.absoluteString as NSString)

    return image
  }
}
