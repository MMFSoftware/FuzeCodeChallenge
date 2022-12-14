//
//  NetworkTests.swift
//  FuseCodeChallengeTests
//
//  Created by Felipe Oliveira on 12/10/22.
//

import XCTest
@testable import FuseCodeChallenge

final class NetworkTests: XCTestCase {
  func testURLRequestProtocolDefaultValues() async throws {
    let sut = URLRequestProtocolDefaultValuesStub(
      url: "https://url.mock.com",
      httpMethod: .post
    )
    let urlRequest = sut.asURLRequest()
    XCTAssertNotNil(urlRequest)
    XCTAssertEqual(urlRequest?.url?.absoluteString, "https://url.mock.com")
    XCTAssertNil(urlRequest?.httpBody)
    XCTAssertEqual(sut.headers.count, 0)
    XCTAssertTrue(sut.urlParameters.isEmpty)
  }

  func testURLRequestProtocolParameters() async throws {
    let sut = URLRequestProtocolStub(
      url: "https://url.mock.com",
      httpMethod: .post, headers: ["header one": "header value one"],
      urlParameters: [URLQueryItem(name: "query one", value: "value query one")],
      bodyParameters: ["body one": "body value one"]
    )
    let urlRequest = sut.asURLRequest()
    XCTAssertNotNil(urlRequest)
    XCTAssertEqual(urlRequest?.url?.absoluteString, "https://url.mock.com?query%20one=value%20query%20one")
    XCTAssertNotNil(urlRequest?.httpBody)
  }

  func testURLRequestProtocolInvalidUrl() async throws {
    let sut = URLRequestProtocolDefaultValuesStub(
      url: "%ˆ&*invalidurlˆ&*",
      httpMethod: .post
    )
    let urlRequest = sut.asURLRequest()
    XCTAssertNil(urlRequest)
  }
}

struct URLRequestProtocolStub: URLRequestProtocol {
  var url: String
  var httpMethod: HTTPMethod
  var headers: [String: String]
  var urlParameters: [URLQueryItem]
  var bodyParameters: [String: Any]
}

struct URLRequestProtocolDefaultValuesStub: URLRequestProtocol {
  var url: String
  var httpMethod: HTTPMethod
}
