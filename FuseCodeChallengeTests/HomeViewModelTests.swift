//
//  FuseCodeChallengeTests.swift
//  FuseCodeChallengeTests
//
//  Created by Felipe Oliveira on 12/10/22.
//

import Combine
import XCTest
@testable import FuseCodeChallenge

final class HomeViewModelTests: XCTestCase {
  var sut: HomeViewModelProtocol!
  var state: HomeState!
  var cancellables: Set<AnyCancellable> = []

  override func setUp() async throws {
    try await super.setUp()
    let networkProviderMock = NetworkProviderMock()
    networkProviderMock.mock = PandascoreAPIMocks.matchesMock
    let pandascoreAPI = PandascoreAPI(networkProvider: networkProviderMock)

    sut = HomeViewModel(pandascoreAPI: pandascoreAPI)
  }

  func testInitialState() throws {
    XCTAssertEqual(sut.numberOfRows(in: 0), 0)
    XCTAssertNil(sut.match(at: IndexPath(row: 0, section: 0)))
  }

  func testFetchGames() throws {
    let expectation = XCTestExpectation(description: "Publishes the ready state")
    bind(statePublisherExpectation: expectation, dropCount: 2)
    sut.refresh()
    wait(for: [expectation], timeout: ExpectationTimeout.large.rawValue)
    XCTAssertEqual(state, .ready)
    XCTAssertEqual(sut.numberOfRows(in: 0), 2)
    XCTAssertEqual(sut.numberOfSections(), 1)
    let firstMatch = try XCTUnwrap(sut.match(at: IndexPath(row: 0, section: 0)))
    XCTAssertEqual(firstMatch.name, "Match 1")
    XCTAssertEqual(firstMatch.opponents.count, 2)
  }
}

extension HomeViewModelTests {
  func bind(statePublisherExpectation: XCTestExpectation, dropCount: Int = 1) {
    sut.statePublisher
      .dropFirst(dropCount)
      .sink { state in
        self.state = state
        statePublisherExpectation.fulfill()
      }.store(in: &cancellables)
  }
}
