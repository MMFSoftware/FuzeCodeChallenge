//
//  UITableView+Register.swift
//  FuseCodeChallenge
//
//  Created by Felipe Oliveira on 12/11/22.
//

import UIKit

extension UITableView {
  func register<T: UITableViewCell>(_: T.Type) where T: ReusableView {
    register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
  }

  func register<T: UITableViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
    let bundle = Bundle(for: T.self)
    let nib = UINib(nibName: T.nibName, bundle: bundle)
    register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
  }

  func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T? where T: ReusableView {
    guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
      log.error("%@", "Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
      return nil
    }

    return cell
  }

  func registerHeaderAndFooter<T>(_: T.Type) where T: UITableViewHeaderFooterView, T: ReusableView {
    register(T.self, forHeaderFooterViewReuseIdentifier: T.defaultReuseIdentifier)
  }

  func registerHeaderAndFooter<T>(_: T.Type) where T: UITableViewHeaderFooterView, T: ReusableView, T: NibLoadableView {
    let bundle = Bundle(for: T.self)
    let nib = UINib(nibName: T.nibName, bundle: bundle)
    register(nib, forHeaderFooterViewReuseIdentifier: T.defaultReuseIdentifier)
  }

  func dequeueReusableHeaderFooterView<T>() -> T? where T: ReusableView {
    guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.defaultReuseIdentifier) as? T else {
      log.error("%@", "Could not dequeue header view with identifier: \(T.defaultReuseIdentifier)")
      return nil
    }
    return view
  }
}
