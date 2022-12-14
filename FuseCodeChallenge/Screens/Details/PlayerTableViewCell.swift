//
//  PlayerTableViewCell.swift
//  FuseCodeChallenge
//
//  Created by Felipe Oliveira on 12/13/22.
//

import UIKit

class PlayerTableViewCell: UITableViewCell, NibLoadableView, ReusableView {
  private let viewModel = PlayerTableViewCellViewModel()

  @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var nicknameLabel: UILabel!
  @IBOutlet weak var container: UIView!
  @IBOutlet weak var playerImage: UIImageView!
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }

  func setupUI() {
    selectionStyle = .none
    nicknameLabel.font = UIFont.font(of: .roboto, weight: .bold, size: 14)
    nameLabel.font = UIFont.font(of: .roboto, size: 12)

    container.layer.cornerRadius = 12
    container.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]

    playerImage.layer.cornerRadius = 8
    playerImage.backgroundColor = UIColor.AppColors.appGray.color
  }

  override func prepareForReuse() {
    super.prepareForReuse()
  }

  func setup(with player: PandascoreTeam.Player) {
    viewModel.setup(with: player)

    nicknameLabel.text = viewModel.nickname
    nameLabel.text = viewModel.name

    handleImage()
  }

  private func handleImage() {
    Task {
      imageActivityIndicator.startAnimating()
      guard let image = await viewModel.downloadPlayerImage() else {
        handleNoImage(imageView: playerImage)
        return
      }
      if Task.isCancelled {
        handleNoImage(imageView: playerImage)
        return
      }
      playerImage.image = image
      imageActivityIndicator.stopAnimating()
    }
  }

  private func handleNoImage(imageView: UIImageView) {
    imageView.backgroundColor = UIColor.AppColors.appGray.color
    imageActivityIndicator.stopAnimating()
  }
}
