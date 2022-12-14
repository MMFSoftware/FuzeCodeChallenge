//
//  PandascoreEndpoint.swift
//  FuseCodeChallenge
//
//  Created by Felipe Oliveira on 12/10/22.
//

import Foundation

class PandascoreEndpoint: URLRequestProtocol {
  var url: String
  var httpMethod: HTTPMethod = .get
  var urlParameters: [URLQueryItem]
  var headers: [String: String] = [:]

  init(url: String, urlParameters: [URLQueryItem] = []) {
    self.urlParameters = urlParameters
    self.url = url
    setupHeaders()
  }

  init(url: String, urlParameters: [String: String]) {
    self.urlParameters = []

    let sortedParameters = urlParameters.sorted(by: {$0.0 < $1.0})
    for (key, value) in sortedParameters {
      self.urlParameters.append(URLQueryItem(name: key, value: value))
    }
    self.url = url
    setupHeaders()
  }

  private func setupHeaders() {
    headers = [
      "accept": "application/json",
      "Authorization": "Bearer DPtnujZFcFCbvmY4xlJoMw1GVskDqi0gJQy6IUJko9_Vr-9m84I"
    ]
  }
}
