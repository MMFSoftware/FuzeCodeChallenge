//
//  AlertsProtocol.swift
//  FuseCodeChallenge
//
//  Created by Felipe Oliveira on 12/10/22.
//

import UIKit

protocol AlertsProtocol where Self: UIViewController {
  func showError(_ message: String) -> UIAlertController
  func showAlert(title: String, message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)?) -> UIAlertController
}

extension AlertsProtocol {
  @discardableResult
  func showError(_ message: String) -> UIAlertController { showAlert(title: "Error", message: message) }

  @discardableResult
  func showAlert(
    title: String,
    message: String,
    buttonTitle: String = "OK",
    handler: ((UIAlertAction) -> Void)? = nil
  ) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: handler))
    present(alert, animated: true, completion: nil)
    return alert
  }
}
