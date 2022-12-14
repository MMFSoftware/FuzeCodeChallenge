//
//  DetailsViewModelTests.swift
//  FuseCodeChallengeTests
//
//  Created by Felipe Oliveira on 12/14/22.
//

import Combine
import XCTest
@testable import FuseCodeChallenge

final class DetailsViewModelTests: XCTestCase {
  var sut: DetailsViewModelProtocol!
  var state: DetailsState!
  var cancellables: Set<AnyCancellable> = []

  override func setUp() async throws {
    try await super.setUp()
    let networkProviderMock = NetworkProviderMock()
    networkProviderMock.mock = PandascoreAPIMocks.teamsMock

    let pandascoreAPI = PandascoreAPI(networkProvider: networkProviderMock)

    let match = PandascoreAPIMocks.matchMock()
    sut = DetailsViewModel(match: match, pandascoreAPI: pandascoreAPI)
  }

  func testInitialState() throws {
    XCTAssertEqual(sut.numberOfRows(in: 0, isTeam1: true), 0)
    XCTAssertNil(sut.player(at: IndexPath(row: 0, section: 0), isTeam1: true))
  }

  func testFetchTeams() throws {
    let expectation = XCTestExpectation(description: "Publishes the ready state")
    bind(statePublisherExpectation: expectation, dropCount: 2)
    sut.fetch()
    wait(for: [expectation], timeout: ExpectationTimeout.large.rawValue)
    XCTAssertEqual(state, .ready)
    XCTAssertEqual(sut.numberOfRows(in: 0, isTeam1: true), 5)
    XCTAssertEqual(sut.numberOfSections(), 1)
    let firstPlayer = try XCTUnwrap(sut.player(at: IndexPath(row: 0, section: 0), isTeam1: true))
    XCTAssertEqual(firstPlayer.name, "player1")
    XCTAssertEqual(firstPlayer.firstName, "John 1")

    XCTAssertEqual(sut.title, "Mock League Mock Serie")
    XCTAssertEqual(sut.time, "12.14.21, 10:31")
    XCTAssertEqual(sut.team1, "Felipe")
    XCTAssertEqual(sut.team2, "John")
  }
}

extension DetailsViewModelTests {
  func bind(statePublisherExpectation: XCTestExpectation, dropCount: Int = 1) {
    sut.statePublisher
      .dropFirst(dropCount)
      .sink { state in
        self.state = state
        statePublisherExpectation.fulfill()
      }.store(in: &cancellables)
  }
}
