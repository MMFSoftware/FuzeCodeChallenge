//
//  NetworkLogger.swift
//  FuseCodeChallenge
//
//  Created by Felipe Oliveira on 12/10/22.
//

import Foundation
import OSLog

class NetworkLogger {

  static let verbose: Bool = false // handles the request logs detail that we want to log in console

  static func logRequest(request: URLRequest) {
#if DEBUG
    if NetworkLogger.verbose {
      var requestDebugLog = "\n==REQUEST===============================================\n"
      requestDebugLog += "🎯🎯🎯 URL: \(request.url?.absoluteString ?? "")\n"
      requestDebugLog += "-----------------------------------------------------------\n"
      requestDebugLog += "⚒⚒⚒ HTTP METHOD: \(request.httpMethod ?? "")\n"
      requestDebugLog += "-----------------------------------------------------------\n"
      requestDebugLog += "📝📝📝 HEADERS: \(request.allHTTPHeaderFields ?? [:])\n"
      requestDebugLog += "-----------------------------------------------------------\n"
      log.debug("%@", requestDebugLog)
    }
#endif
  }

  static func logResponse(_ response: URLResponse?, _ data: Data?) {
#if DEBUG
    var responseDebugLog = "\n==RESPONSE==============================================\n"
    responseDebugLog += "🎯🎯🎯 URL: \(response?.url?.absoluteString ?? "")\n"
    responseDebugLog += "-----------------------------------------------------------\n"
    responseDebugLog += "✅✅✅ STATUS CODE: \((response as? HTTPURLResponse)?.statusCode ?? -1)\n"
    responseDebugLog += "-----------------------------------------------------------\n"
    if NetworkLogger.verbose {
      responseDebugLog += "📝📝📝 HEADERS: \((response as? HTTPURLResponse)?.allHeaderFields as? [String: String] ?? [:])\n"
      responseDebugLog += "-----------------------------------------------------------\n"

      if let dataObj = data {
        do {
          let json = try JSONSerialization.jsonObject(with: dataObj, options: .mutableContainers)
          let prettyPrintedData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
          responseDebugLog += "📎📎📎 RESPONSE DATA: \n\(String(bytes: prettyPrintedData, encoding: .utf8) ?? "")"
        } catch {
          responseDebugLog += "📎📎📎 RESPONSE DATA: \n\(String(data: dataObj, encoding: .utf8) ?? "")"
        }
        responseDebugLog += "\n"
      }
      responseDebugLog += "===========================================================\n"
    }
    log.debug("%@", responseDebugLog)
#endif
  }

  static func logResponseError(_ response: URLResponse?, _ data: Data?) {
#if DEBUG
    var responseDebugLog = "\n==RESPONSE==============================================\n"
    responseDebugLog += "🎯🎯🎯 URL: \(response?.url?.absoluteString ?? "")\n"
    responseDebugLog += "-----------------------------------------------------------\n"
    responseDebugLog += "⚠️⚠️⚠️ STATUS CODE: \((response as? HTTPURLResponse)?.statusCode ?? -1)\n"
    responseDebugLog += "-----------------------------------------------------------\n"
    responseDebugLog += "📒📒📒 HEADERS: \((response as? HTTPURLResponse)?.allHeaderFields as? [String: String] ?? [:])\n"
    responseDebugLog += "-----------------------------------------------------------\n"

    if let dataObj = data, NetworkLogger.verbose {
      do {
        let json = try JSONSerialization.jsonObject(with: dataObj, options: .mutableContainers)
        let prettyPrintedData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        responseDebugLog += "📎📎📎 🧨🧨🧨 RESPONSE ERROR: \n\(String(bytes: prettyPrintedData, encoding: .utf8) ?? "")"
      } catch {
        responseDebugLog += "📎📎📎  🧨🧨🧨 RESPONSE ERROR: \n\(String(data: dataObj, encoding: .utf8) ?? "")"
      }
      responseDebugLog += "\n"
    }

    responseDebugLog += "===========================================================\n"
    log.debug("%@", responseDebugLog)
#endif
  }

  static func logError(on requestUrl: String?, message: String) {
#if DEBUG
    var responseDebugLog = "\n==NETWORK ERROR==============================================\n"
    responseDebugLog += "🎯🎯🎯 URL: \(requestUrl ?? "")\n"
    responseDebugLog += "-----------------------------------------------------------\n"
    responseDebugLog += "🧨🧨🧨 ERROR: \(message)\n"
    responseDebugLog += "-----------------------------------------------------------\n"
    log.error("%@", responseDebugLog)
#endif
  }
}
