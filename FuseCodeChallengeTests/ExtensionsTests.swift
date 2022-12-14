//
//  ExtensionsTests.swift
//  FuseCodeChallengeTests
//
//  Created by Felipe Oliveira on 12/14/22.
//

import XCTest
@testable import FuseCodeChallenge
final class ExtensionsTests: XCTestCase {
  func testSafeCollection() {
    let sut = [1, 2, 3, 4, 5]
    XCTAssertNotNil(sut[safe: 1])
    XCTAssertEqual(sut[safe: 2], 3)
    XCTAssertNil(sut[safe: 10])
  }

  func testDateCustom() throws {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm"
    let someDateTime = try XCTUnwrap(formatter.date(from: "2021/12/14 22:31"))

    let customString = someDateTime.custom()
    XCTAssertEqual(customString, "12.14.21, 10:31")
  }
}
