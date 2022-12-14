//
//  PandascoreGamesResponse.swift
//  FuseCodeChallenge
//
//  Created by Felipe Oliveira on 12/10/22.
//

import Foundation

struct PandascoreMatch: Codable {
  let name: String
  let league: League
  let serie: Serie
  let scheduledAt: Date?
  let beginAt: Date?
  let id: Int

  let opponents: [OpponentWrapper]
  let status: MatchStatus

  enum CodingKeys: String, CodingKey {
    case name
    case league
    case serie
    case scheduledAt = "scheduled_at"
    case beginAt = "begin_at"
    case opponents
    case status
    case id
  }

  struct League: Codable {
    let id: Int
    let imageUrl: String?
    let name: String

    enum CodingKeys: String, CodingKey {
      case imageUrl = "image_url"
      case id
      case name
    }
  }

  struct Serie: Codable {
    let id: Int
    let name: String?
  }

  enum MatchStatus: String, Codable {
    case canceled
    case finished
    case notStarted = "not_started"
    case postponed
    case running
  }

  struct OpponentWrapper: Codable {
    let opponent: Opponent
  }

  struct Opponent: Codable {
    let id: Int
    let imageUrl: String?
    let name: String

    enum CodingKeys: String, CodingKey {
      case imageUrl = "image_url"
      case id
      case name
    }
  }
}
