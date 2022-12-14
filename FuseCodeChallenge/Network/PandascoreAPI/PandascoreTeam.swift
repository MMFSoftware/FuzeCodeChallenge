//
//  PandascoreTeam.swift
//  FuseCodeChallenge
//
//  Created by Felipe Oliveira on 12/13/22.
//

import UIKit

struct PandascoreTeam: Codable {
  let players: [Player]

  struct Player: Codable {
    let firstName: String?
    let lastName: String
    let imageUrl: String?
    let name: String

    enum CodingKeys: String, CodingKey {
      case firstName = "first_name"
      case lastName = "last_name"
      case imageUrl = "image_url"
      case name
    }
  }  
}

extension PandascoreTeam.Player {
  func downloadImage() async -> UIImage? {
    guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else { return nil }

    return try? await RemoteImage.shared.load(url: url)
  }
}
