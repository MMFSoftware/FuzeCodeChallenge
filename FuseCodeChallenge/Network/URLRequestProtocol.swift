//
//  URLRequestProtocol.swift
//  FuseCodeChallenge
//
//  Created by Felipe Oliveira on 12/10/22.
//

import Foundation

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case patch = "PATCH"
  case delete = "DELETE"
}

// MARK: - Protocol
protocol URLRequestProtocol {
  var url: String { get }
  var httpMethod: HTTPMethod { get }
  var headers: [String: String] { get }
  var urlParameters: [URLQueryItem] { get }
  var bodyParameters: [String: Any] { get }
  var timeOut: TimeInterval { get }
  func asURLRequest() -> URLRequest?
}

extension URLRequestProtocol {
  var headers: [String: String] { [:] }

  var urlParameters: [URLQueryItem] { [] }
  var bodyParameters: [String: Any] { [:] }
  var timeOut: TimeInterval { 30 }

  // MARK: - Instance Methods
  func asURLRequest() -> URLRequest? {
    guard let url = URL(string: url) else { return nil }

    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
    if var queryItems = urlComponents?.queryItems {
      queryItems.append(contentsOf: urlParameters)
      urlComponents?.queryItems = queryItems
    } else {
      urlComponents?.queryItems = urlParameters
    }

    var urlRequest: URLRequest

    if let queryItems = urlComponents?.queryItems, !queryItems.isEmpty {
      urlRequest = URLRequest(url: urlComponents?.url ?? url)
    } else {
      urlRequest = URLRequest(url: url)
    }

    if !bodyParameters.isEmpty {
      let httpBodyParameters = try? JSONSerialization.data(withJSONObject: bodyParameters, options: [])
      urlRequest.httpBody = httpBodyParameters
    }

    headers.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
    urlRequest.httpMethod = httpMethod.rawValue
    urlRequest.timeoutInterval = timeOut

    return urlRequest
  }
}
