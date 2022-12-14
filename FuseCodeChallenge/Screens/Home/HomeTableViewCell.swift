//
//  HomeTableViewCell.swift
//  FuseCodeChallenge
//
//  Created by Felipe Oliveira on 12/11/22.
//

import UIKit
class HomeTableViewCell: UITableViewCell, NibLoadableView, ReusableView {
  @IBOutlet weak var leagueLabel: UILabel!
  @IBOutlet weak var timeLabelContainer: UIView!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var cardContainer: UIView!
  @IBOutlet weak var leagueImage: UIImageView!
  @IBOutlet weak var leagueActivityIndicator: UIActivityIndicatorView!

  @IBOutlet weak var vsLabel: UILabel!
  @IBOutlet weak var team1Label: UILabel!
  @IBOutlet weak var team1Image: UIImageView!
  @IBOutlet weak var team1ActivityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var team2Label: UILabel!
  @IBOutlet weak var team2Image: UIImageView!
  @IBOutlet weak var team2ActivityIndicator: UIActivityIndicatorView!

  private let viewModel = HomeTableViewCellViewModel()

  private let animationDuration: CGFloat = 0.3

  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }

  private func setupUI() {
    selectionStyle = .none
    cardContainer.layer.cornerRadius = 16
    [leagueLabel, timeLabel].forEach {
      $0.font = UIFont.font(of: .roboto, size: 8)
    }

    timeLabelContainer.layer.cornerRadius = 16
    timeLabelContainer.layer.maskedCorners = [.layerMinXMaxYCorner]

    vsLabel.font = UIFont.font(of: .roboto, size: 12)
    [team1Label, team2Label].forEach {
      $0.font = UIFont.font(of: .roboto, size: 10)
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    [leagueImage, team1Image, team2Image].forEach {
      $0.backgroundColor = .clear
      $0.layer.cornerRadius = 0
      $0.image = nil
    }
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    guard selected else { return }
    cardContainer.backgroundColor = UIColor.AppColors.cardBgHighlighted.color

    UIView.animate(withDuration: animationDuration, animations: { [weak self] in
      self?.cardContainer.transform = CGAffineTransform(scaleX: 1.03, y: 1.03)
    }) { (_) in
      UIView.animate(withDuration: self.animationDuration, animations: { [weak self] in
        self?.cardContainer.transform = CGAffineTransform.identity
        self?.cardContainer.backgroundColor = UIColor.AppColors.cardBg.color
      })
    }
  }

  func setup(with match: PandascoreMatch) {
    viewModel.setup(with: match)

    leagueLabel.text = viewModel.leagueSerieName
    timeLabel.text = viewModel.time
    timeLabelContainer.backgroundColor = viewModel.timeColor

    team1Label.text = viewModel.team1
    team2Label.text = viewModel.team2

    handleLeagueImage()
    handleTeam1Image()
    handleTeam2Image()
  }

  private func handleLeagueImage() {
    Task {
      leagueActivityIndicator.startAnimating()
      guard let image = await viewModel.downloadLeagueImage() else {
        handleNoImage(imageView: leagueImage, radius: 8, activityIndicator: leagueActivityIndicator)
        return
      }
      if Task.isCancelled {
        handleNoImage(imageView: leagueImage, radius: 8, activityIndicator: leagueActivityIndicator)
        return
      }
      leagueImage.image = image
      leagueActivityIndicator.stopAnimating()
    }
  }

  private func handleTeam1Image() {
    Task {
      team1ActivityIndicator.startAnimating()
      guard let image = await viewModel.downloadTeam1Image() else {
        handleNoImage(imageView: team1Image, radius: 30, activityIndicator: team1ActivityIndicator)
        return
      }
      if Task.isCancelled {
        handleNoImage(imageView: team1Image, radius: 30, activityIndicator: team1ActivityIndicator)
        return
      }
      team1Image.image = image
      team1ActivityIndicator.stopAnimating()
    }
  }

  private func handleTeam2Image() {
    Task {
      team2ActivityIndicator.startAnimating()
      guard let image = await viewModel.downloadTeam2Image() else {
        handleNoImage(imageView: team2Image, radius: 30, activityIndicator: team2ActivityIndicator)
        return
      }
      if Task.isCancelled {
        handleNoImage(imageView: team2Image, radius: 30, activityIndicator: team2ActivityIndicator)
        return
      }
      team2Image.image = image
      team2ActivityIndicator.stopAnimating()
    }
  }

  private func handleNoImage(
    imageView: UIImageView,
    radius: CGFloat,
    activityIndicator: UIActivityIndicatorView
  ) {
    imageView.backgroundColor = UIColor.AppColors.appGray.color
    imageView.layer.cornerRadius = radius
    activityIndicator.stopAnimating()
  }
}
