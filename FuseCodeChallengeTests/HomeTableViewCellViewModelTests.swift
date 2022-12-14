//
//  HomeTableViewCellViewModelTests.swift
//  FuseCodeChallengeTests
//
//  Created by Felipe Oliveira on 12/14/22.
//

import XCTest
@testable import FuseCodeChallenge

final class HomeTableViewCellViewModelTests: XCTestCase {
  var sut: HomeTableViewCellViewModel!

  override func setUp() async throws {
    try await super.setUp()
    sut = HomeTableViewCellViewModel()
    sut.setup(with: PandascoreAPIMocks.matchMock())
  }

  func testStrings() throws {
    XCTAssertEqual(sut.leagueSerieName, "Mock League Mock Serie")
    XCTAssertEqual(sut.time, "12.14.21, 10:31")
    XCTAssertEqual(sut.team1, "Felipe")
    XCTAssertEqual(sut.team2, "John")
  }
}
