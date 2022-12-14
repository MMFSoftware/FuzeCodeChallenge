//
//  DetailsViewModel.swift
//  FuseCodeChallenge
//
//  Created by Felipe Oliveira on 12/13/22.
//

import Combine
import UIKit

enum DetailsState: Equatable {
  case error(String)
  case loading
  case ready

  static func == (lhs: DetailsState, rhs: DetailsState) -> Bool {
    switch (lhs, rhs) {
    case (.loading, .loading): return true
    case (.error, .error): return true
    case (.ready, .ready): return true
    default: return false
    }
  }
}

  protocol DetailsViewModelProtocol {
    var statePublisher: Published<DetailsState>.Publisher { get }
    var title: String { get }
    var time: String { get }
    var team1: String { get }
    var team2: String { get }
    func downloadTeam1Image() async -> UIImage?
    func downloadTeam2Image() async -> UIImage?
    func fetch()
    
    func numberOfSections() -> Int
    func numberOfRows(in section: Int, isTeam1: Bool) -> Int
    func player(at index: IndexPath, isTeam1: Bool) -> PandascoreTeam.Player?
  }

  class DetailsViewModel: DetailsViewModelProtocol {
    var statePublisher: Published<DetailsState>.Publisher { $state }
    @Published var state: DetailsState = .loading
    private let pandascoreAPI: PandascoreAPIProtocol
    private var match: PandascoreMatch
    private var players1: [PandascoreTeam.Player]
    private var players2: [PandascoreTeam.Player]

    init(
      match: PandascoreMatch,
      pandascoreAPI: PandascoreAPIProtocol = PandascoreAPI()
    ) {
      self.pandascoreAPI = pandascoreAPI
      self.match = match
      self.players1 = []
      self.players2 = []
    }

    var title: String { match.leagueSeries }
    
    var time: String { match.timeFormatted }

    var team1: String { match.team1 }

    var team2: String { match.team2 }

    func downloadTeam1Image() async -> UIImage? {
      return await match.downloadTeam1Image()
    }

    func downloadTeam2Image() async -> UIImage? {
      return await match.downloadTeam2Image()
    }

    // MARK: - API Data
    func fetch() {
      state = .loading
      let team1 = match.opponents.first?.opponent
      let team2 = match.opponents.last?.opponent

      Task {
        do {
          if let team1 = team1 {
            players1 = try await pandascoreAPI.fetchTeam(teamId: team1.id)?.players ?? []
          } else {
            players1 = []
          }
          if let team2 = team2 {
            players2 = try await pandascoreAPI.fetchTeam(teamId: team2.id)?.players ?? []
          } else {
            players2 = []
          }
          state = .ready
        } catch {
          state = .error(error.localizedDescription)
        }
      }
    }

    private func players(isTeam1: Bool) -> [PandascoreTeam.Player] { isTeam1 ? players1 : players2 }

    func numberOfSections() -> Int { 1 }

    func numberOfRows(in section: Int, isTeam1: Bool) -> Int { players(isTeam1: isTeam1).count }

    func player(at index: IndexPath, isTeam1: Bool) -> PandascoreTeam.Player? {
      players(isTeam1: isTeam1)[safe: index.row]
    }
}
