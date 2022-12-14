//
//  ProcessInfo+Testing.swift
//  FuseCodeChallenge
//
//  Created by Felipe Oliveira on 12/11/22.
//

import Foundation

extension ProcessInfo {
  static func isTesting() -> Bool {
    return ProcessInfo.processInfo.arguments.contains("TESTING")
  }
  
  static func isUnitTesting() -> Bool {
    return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
  }
}
