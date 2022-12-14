//
//  PlayerTableViewCellViewModel.swift
//  FuseCodeChallenge
//
//  Created by Felipe Oliveira on 12/13/22.
//

import UIKit

class PlayerTableViewCellViewModel {
  private var player: PandascoreTeam.Player?

  func setup(with player: PandascoreTeam.Player) {
    self.player = player
  }

  var nickname: String { player?.name ?? "" }
  var name: String { "\(player?.firstName ?? "") \(player?.lastName ?? "")" }

  func downloadPlayerImage() async -> UIImage? {
    guard let player = self.player else { return nil }
    return await player.downloadImage()
  }
}
