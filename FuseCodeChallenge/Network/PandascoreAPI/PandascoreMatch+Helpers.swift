//
//  PandascoreMatch+Helpers.swift
//  FuseCodeChallenge
//
//  Created by Felipe Oliveira on 12/13/22.
//

import UIKit

extension PandascoreMatch {
  var team1: String {
    guard
      let opponent = opponents.first?.opponent
    else { return "" }

    return opponent.name
  }

  var team2: String {
    guard
      let opponent = opponents.last?.opponent
    else { return "" }

    return opponent.name
  }

  var leagueSeries: String { "\(league.name) \(serie.name ?? "")" }

  var timeFormatted: String {
    guard status != .running else { return "AGORA" }

    if let date = beginAt {
      return date.custom()
    } else {
      return  "-"
    }
  }

  // MARK: - Image download
  func downloadLeagueImage() async -> UIImage? {
    guard let leagueImageUrl = league.imageUrl, let imageUrl = URL(string: leagueImageUrl) else { return nil }
    return await downloadImage(url: imageUrl)
  }

  func downloadTeam1Image() async -> UIImage? {
    guard
      let firstOpponent = opponents.first?.opponent,
      let imageUrl = firstOpponent.imageUrl, let url = URL(string: imageUrl) else { return nil }
    return await downloadImage(url: url)
  }

  func downloadTeam2Image() async -> UIImage? {
    guard
      let lastOpponent = opponents.last?.opponent,
      let imageUrl = lastOpponent.imageUrl, let url = URL(string: imageUrl) else { return nil }
    return await downloadImage(url: url)
  }

  private func downloadImage(url: URL) async -> UIImage? {
    return try? await RemoteImage.shared.load(url: url)
  }
}
