//
//  UIColor+Custom.swift
//  FuseCodeChallenge
//
//  Created by Felipe Oliveira on 12/10/22.
//

import UIKit

extension UIColor {
  enum AppColors: String {
    case appBg
    case cardBg
    case main
    case separator
    case appGray
    case white50
    case cardBgHighlighted
    case playerName

    var color: UIColor { UIColor(named: self.rawValue) ?? UIColor.red }
  }
}
