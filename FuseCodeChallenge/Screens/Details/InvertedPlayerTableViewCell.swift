//
//  InvertedPlayerTableViewCell.swift
//  FuseCodeChallenge
//
//  Created by Felipe Oliveira on 12/13/22.
//

import UIKit

class InvertedPlayerTableViewCell: PlayerTableViewCell {
  override func setupUI() {
    super.setupUI()

    container.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
  }
}
