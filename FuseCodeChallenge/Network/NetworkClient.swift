//
//  NetworkClient.swift
//  FuseCodeChallenge
//
//  Created by Felipe Oliveira on 12/10/22.
//

import Foundation

protocol NetworkProviderProtocol {
  func fetch<T: Decodable>(endpoint: URLRequestProtocol, shouldClearCache: Bool) async throws -> T
  func send(endpoint: URLRequestProtocol) async throws
}

class NetworkProvider: NetworkProviderProtocol {
  // MARK: - Properties
  private let configuration: URLSessionConfiguration = {
    let config = URLSessionConfiguration.default
    config.httpAdditionalHeaders = ["Content-Type": "application/json"]

    return config
  }()

  private func getResponseError(response: URLResponse) -> NetworkError? {
    guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
      return .requestFailed(error: "No status code")
    }
    guard isSuccess(statusCode) else {
      return .responseUnsuccessful(statusCode: statusCode)
    }

    return nil
  }

  private func isSuccess(_ statusCode: Int) -> Bool { 200..<300 ~= statusCode }

  private func clearCache(shouldClearCache: Bool, urlRequest: URLRequest) {
    if shouldClearCache {
      URLCache.shared.removeCachedResponse(for: urlRequest)
      log.debug("Cache cleared for %@", urlRequest.url?.absoluteString ?? "unknown")
    }
  }

  func fetch<T: Decodable>(endpoint: URLRequestProtocol, shouldClearCache: Bool = false) async throws -> T {
    let data = try await request(endpoint: endpoint, shouldClearCache: shouldClearCache)
    do {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      let model = try decoder.decode(T.self, from: data)
      return model
    } catch let DecodingError.dataCorrupted(context) {
      NetworkLogger.logError(on: endpoint.url, message: "JSON Parsing Error: \(context)")
      throw NetworkError.jsonParsingFailure(error: "\(context)")
    } catch let DecodingError.keyNotFound(key, context) {
      let message = "Key '\(key)' not found: \(context.debugDescription), codingPath: \(context.codingPath)"
      NetworkLogger.logError(on: endpoint.url, message: "JSON Parsing Error: \(message)")
      throw NetworkError.jsonParsingFailure(error: "\(message)")
    } catch let DecodingError.valueNotFound(value, context) {
      let message = "Value '\(value)' not found: \(context.debugDescription), codingPath: \(context.codingPath)"
      NetworkLogger.logError(on: endpoint.url, message: "JSON Parsing Error: \(message)")
      throw NetworkError.jsonParsingFailure(error: "\(message)")
    } catch let DecodingError.typeMismatch(type, context) {
      let message = "Type '\(type)' mismatch: \(context.debugDescription), codingPath: \(context.codingPath)"
      NetworkLogger.logError(on: endpoint.url, message: "JSON Parsing Error: \(message)")
      throw NetworkError.jsonParsingFailure(error: "\(message)")
    }
    catch let error {
      NetworkLogger.logError(on: endpoint.url, message: "JSON Parsing Error: \(error.localizedDescription)")
      throw NetworkError.jsonParsingFailure(error: String(describing: error))
    }
  }

  func send(endpoint: URLRequestProtocol) async throws {
    try await request(endpoint: endpoint, shouldClearCache: false)
  }

  @discardableResult
  private func request(endpoint: URLRequestProtocol, shouldClearCache: Bool) async throws -> Data {
    guard let request = endpoint.asURLRequest() else { throw NetworkError.invalidRequest }

    clearCache(shouldClearCache: shouldClearCache, urlRequest: request)
    NetworkLogger.logRequest(request: request)

    let session = URLSession(configuration: configuration)

    do {
      let (data, response) = try await session.data(for: request, delegate: nil)
      NetworkLogger.logResponse(response, data)

      if let errorParsed = self.getResponseError(response: response) {
        NetworkLogger.logResponseError(response, data)
        throw errorParsed
      }
      return data
    } catch let error as NetworkError {
      NetworkLogger.logError(on: request.url?.absoluteString, message: error.localizedDescription)
      throw error
    } catch {
      NetworkLogger.logError(on: request.url?.absoluteString, message: error.localizedDescription)
      throw NetworkError.requestFailed(error: String(describing: error))
    }
  }
}
