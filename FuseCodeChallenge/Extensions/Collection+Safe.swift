//
//  Collection+Safe.swift
//  FuseCodeChallenge
//
//  Created by Felipe Oliveira on 12/10/22.
//

import Foundation

public extension Collection {
  subscript (safe index: Self.Index) -> Iterator.Element? {
    (startIndex ..< endIndex).contains(index) ? self[index] : nil
  }
}
