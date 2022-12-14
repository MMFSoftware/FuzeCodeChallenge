//
//  ReusableView.swift
//  FuseCodeChallenge
//
//  Created by Felipe Oliveira on 12/11/22.
//

import UIKit

public protocol ReusableView: AnyObject {
  static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
  public static var defaultReuseIdentifier: String {
    return String(describing: self)
  }
}

public protocol NibLoadableView: AnyObject {
  static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
  static var nibName: String { String(describing: self) }
}
