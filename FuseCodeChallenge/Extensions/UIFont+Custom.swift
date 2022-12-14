//
//  UIFont+Custom.swift
//  FuseCodeChallenge
//
//  Created by Felipe Oliveira on 12/10/22.
//

import UIKit

/// Font Enum that holds our custom fonts
public enum FontName {
  case roboto

  func name(weight: FontWeight) -> String {
    let weightName = weight.name
    let fontName = "Roboto"
    return "\(fontName)-\(weightName)"
  }
}

/// Fonts weights available
public enum FontWeight {
  case bold
  case medium
  case regular
  case light
  case italic
  case semibold

  var name: String {
    switch self {

    case .bold: return "Bold"
    case .semibold: return "Semibold"
    case .regular: return "Regular"
    case .medium: return "Medium"
    case .light: return "Light"
    case .italic: return "Italic"
    }
  }
}

/// Extension to set the scaled and custom fonts
public extension UIFont {
  private static func customFont(name: String, size: CGFloat) -> UIFont {
    let font = UIFont(name: name, size: size)
    assert(font != nil, "Can't load font: \(name)")
    return font ?? UIFont.systemFont(ofSize: size)
  }

  private static func scaledFont(size: CGFloat, name: String, textStyle: UIFont.TextStyle, maxSize: CGFloat? = nil) -> UIFont {
    let font = UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    let fontMetrics = UIFontMetrics(forTextStyle: textStyle)

    if let maxSize = maxSize {
      return fontMetrics.scaledFont(for: font, maximumPointSize: maxSize)
    } else {
      return fontMetrics.scaledFont(for: font)
    }
  }

  static func font(of type: FontName, weight: FontWeight = .regular, size: CGFloat) -> UIFont {
    return customFont(name: type.name(weight: weight),
                      size: size)
  }

  static func scaledfont(of type: FontName, weight: FontWeight, size: CGFloat, maxSize: CGFloat? = nil, textStyle: UIFont.TextStyle = .body) -> UIFont {
    return scaledFont(size: size,
                      name: type.name(weight: weight),
                      textStyle: textStyle,
                      maxSize: maxSize)
  }
}
