//
//  AppDelegate+Appearance.swift
//  FuseCodeChallenge
//
//  Created by Felipe Oliveira on 12/10/22.
//

import Foundation

import UIKit

extension AppDelegate {
  func setGlobalAppearance() {
    setupNavigationBarAppearance()
  }

  // MARK: - UINavigationBar
  private func setupNavigationBarAppearance() {
    let appearance = getBaseNavigationBarAppearance()
    appearance.backgroundColor = UIColor.AppColors.appBg.color

    let backButton = UIImage(systemName: "arrow.left")
    appearance.setBackIndicatorImage(backButton, transitionMaskImage: backButton)

    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    UINavigationBar.appearance().tintColor = .white

    appearance.backButtonAppearance = setupUIBarButtonItemAppearance()
  }

  private func getBaseNavigationBarAppearance() -> UINavigationBarAppearance {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white,
      NSAttributedString.Key.font: UIFont.font(of: .roboto, weight: .bold, size: 18)
    ]

    return appearance
  }

  // MARK: - UIBarButtonItem
  private func setupUIBarButtonItemAppearance() -> UIBarButtonItemAppearance {
    let button = UIBarButtonItemAppearance(style: .plain)
    button.normal.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white,
      NSAttributedString.Key.font: UIFont.font(of: .roboto, weight: .bold, size: 18)
    ]
    return button

  }

}
