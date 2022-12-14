//
//  HomeTableViewCellViewModel.swift
//  FuseCodeChallenge
//
//  Created by Felipe Oliveira on 12/13/22.
//

import UIKit

class HomeTableViewCellViewModel {
  private var match: PandascoreMatch?

  func setup(with match: PandascoreMatch) {
    self.match = match
  }

  var leagueSerieName: String { match?.leagueSeries ?? "" }

  var time: String { match?.timeFormatted ?? "" }

  var timeColor: UIColor {
    let defaultBgColor = UIColor.AppColors.separator.color
    guard let match = self.match else { return defaultBgColor }
    return (match.status == .running)
    ? UIColor.AppColors.main.color
    : defaultBgColor
  }

  func downloadLeagueImage() async -> UIImage? {
    guard let match = self.match else { return nil }
    return await match.downloadLeagueImage()
  }

  func downloadTeam1Image() async -> UIImage? {
    guard let match = self.match else { return nil }
    return await match.downloadTeam1Image()
  }

  func downloadTeam2Image() async -> UIImage? {
    guard let match = self.match else { return nil }
    return await match.downloadTeam2Image()
  }

  var team1: String { match?.team1 ?? "" }
  
  var team2: String { match?.team2 ?? "" }
}
