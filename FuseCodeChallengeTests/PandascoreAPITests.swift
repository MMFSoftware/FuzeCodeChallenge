//
//  PandascoreAPITests.swift
//  FuseCodeChallengeTests
//
//  Created by Felipe Oliveira on 12/10/22.
//

import XCTest
@testable import FuseCodeChallenge

final class PandascoreAPITests: XCTestCase {
  func testMatchGames() async throws {
    let networkProvider = NetworkProviderMock()
    networkProvider.mock = PandascoreAPIMocks.matchesMock

    let sut = PandascoreAPI(networkProvider: networkProvider)
    let response = try await sut.fetchGames()
    XCTAssertEqual(response.count, 2)

    let firstMatch = try XCTUnwrap(response.first)
    XCTAssertEqual(firstMatch.league.name, "Mock League")
    XCTAssertEqual(firstMatch.serie.name, "Mock Serie")
    XCTAssertEqual(firstMatch.opponents.count, 2)

    let firstOpponent = try XCTUnwrap(firstMatch.opponents.first?.opponent)
    XCTAssertEqual(firstOpponent.name, "Felipe")
    XCTAssertEqual(firstOpponent.id, 3)
  }

  func testTeams() async throws {
    let networkProvider = NetworkProviderMock()
    networkProvider.mock = PandascoreAPIMocks.teamsMock

    let sut = PandascoreAPI(networkProvider: networkProvider)
    let response = try await sut.fetchTeam(teamId: 1)
    XCTAssertEqual(response?.players.count, 5)

    let firstPlayer = try XCTUnwrap(response?.players.first)
    XCTAssertEqual(firstPlayer.firstName, "John 1")
    XCTAssertEqual(firstPlayer.lastName, "Smith 1")
    XCTAssertEqual(firstPlayer.name, "player1")
  }
}

class PandascoreAPIMocks {

  static func matchMock(with name: String = "Match 1") -> PandascoreMatch {
    let league = PandascoreMatch.League(id: 1, imageUrl: nil, name: "Mock League")
    let serie = PandascoreMatch.Serie(id: 2, name: "Mock Serie")
    let opponent1 = PandascoreMatch.Opponent(id: 3, imageUrl: "", name: "Felipe")
    let opponent2 = PandascoreMatch.Opponent(id: 4, imageUrl: "", name: "John")
    let opponents = [
      PandascoreMatch.OpponentWrapper(opponent: opponent1),
      PandascoreMatch.OpponentWrapper(opponent: opponent2)
    ]

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm"
    let beginAt = try? XCTUnwrap(formatter.date(from: "2021/12/14 22:31"))

    return PandascoreMatch(
      name: name,
      league: league,
      serie: serie,
      scheduledAt: Date(),
      beginAt: beginAt,
      id: 1,
      opponents: opponents,
      status: .finished
    )
  }

  static var matchesMock: [PandascoreMatch] {
    let match1 = matchMock()
    let match2 = matchMock(with: "Match 2")

    return [match1, match2]
  }

  static var playerMock: PandascoreTeam.Player {
    PandascoreTeam.Player(firstName: "John", lastName: "Smith", imageUrl: nil, name: "player")
  }

  static var teamMock: PandascoreTeam {
    var players: [PandascoreTeam.Player] = []
    for counter in 1...5 {
      let player = PandascoreTeam.Player(firstName: "John \(counter)", lastName: "Smith \(counter)", imageUrl: nil, name: "player\(counter)")
      players.append(player)
    }
    return PandascoreTeam(players: players)
  }

  static var teamsMock: [PandascoreTeam] {
    let team1 = teamMock
    let team2 = teamMock
    return [team1, team2]
  }
}

class NetworkProviderMock: NetworkProviderProtocol {
  var mock: Any?
  func fetch<T>(endpoint: FuseCodeChallenge.URLRequestProtocol, shouldClearCache: Bool) async throws -> T where T: Decodable {
    guard let response =  mock as? T else { fatalError() }
    return response
  }

  func send(endpoint: FuseCodeChallenge.URLRequestProtocol) async throws { }
}
