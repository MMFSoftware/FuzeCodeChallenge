//
//  Timeout.swift
//  FuseCodeChallengeTests
//
//  Created by Felipe Oliveira on 12/11/22.
//

import Foundation

enum Timeout {
  case small
  case medium
  case large
  case veryLarge

  var time: DispatchTimeInterval {
    switch self {
    case .small:
      return .seconds(2)
    case .medium:
      return .seconds(5)
    case .large:
      return .seconds(10)
    case .veryLarge:
      return .seconds(20)
    }
  }
}

enum ExpectationTimeout: Double {
  case small = 0.5
  case medium = 2
  case large = 5
  case extraLarge = 10
}
