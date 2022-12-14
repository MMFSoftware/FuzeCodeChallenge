//
//  PandascoreAPI.swift
//  FuseCodeChallenge
//
//  Created by Felipe Oliveira on 12/10/22.
//

import Foundation

protocol PandascoreAPIProtocol {
  func fetchGames(page: Int) async throws -> [PandascoreMatch]
  func fetchTeam(teamId: Int) async throws -> PandascoreTeam?
}

class PandascoreAPI: PandascoreAPIProtocol {
  private var networkProvider: NetworkProviderProtocol

  private var host: String { "https://api.pandascore.co/csgo/" }

  init(
    networkProvider: NetworkProviderProtocol = NetworkProvider()
  ) {
    self.networkProvider = networkProvider
  }

  func fetchGames(page: Int = 1) async throws -> [PandascoreMatch] {
    let matchesEndpoint = self.host + "matches"

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let todayString = dateFormatter.string(from: Date())

    let urlParams = [
      URLQueryItem(name: "sort", value: "-status,begin_at"),
      URLQueryItem(name: "page", value: "\(page)"),
      URLQueryItem(name: "per_page", value: "50"),
      URLQueryItem(name: "range[begin_at]", value: "\(todayString),2122-12-31")
    ]
    
    let endpoint = PandascoreEndpoint(url: matchesEndpoint, urlParameters: urlParams)

    return try await networkProvider.fetch(endpoint: endpoint, shouldClearCache: false)
  }

  func fetchTeam(teamId: Int) async throws -> PandascoreTeam? {
    let teamsEndpoint = self.host + "teams"

    let urlParams = [
      URLQueryItem(name: "filter[id]", value: "\(teamId)")
    ]
    let endpoint = PandascoreEndpoint(url: teamsEndpoint, urlParameters: urlParams)

    let list: [PandascoreTeam] = try await networkProvider.fetch(endpoint: endpoint, shouldClearCache: false)

    return list.first
  }
}
