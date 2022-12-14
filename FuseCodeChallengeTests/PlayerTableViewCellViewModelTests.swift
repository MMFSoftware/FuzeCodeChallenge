//
//  PlayerTableViewCellViewModelTests.swift
//  FuseCodeChallengeTests
//
//  Created by Felipe Oliveira on 12/14/22.
//

import XCTest
@testable import FuseCodeChallenge

final class PlayerTableViewCellViewModelTests: XCTestCase {
  var sut: PlayerTableViewCellViewModel!

  override func setUp() async throws {
    try await super.setUp()
    sut = PlayerTableViewCellViewModel()
    sut.setup(with: PandascoreAPIMocks.playerMock)
  }

  func testStrings() throws {
    XCTAssertEqual(sut.nickname, "player")
    XCTAssertEqual(sut.name, "John Smith")
  }
}
