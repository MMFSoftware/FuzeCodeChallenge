//
//  DetailsViewController.swift
//  FuseCodeChallenge
//
//  Created by Felipe Oliveira on 12/13/22.
//

import Combine
import UIKit
class DetailsViewController: UIViewController, AlertsProtocol {
  var cancellables: Set<AnyCancellable> = []
  private var viewModel: any DetailsViewModelProtocol

  @IBOutlet weak var team1Label: UILabel!
  @IBOutlet weak var team1Image: UIImageView!
  @IBOutlet weak var team2Label: UILabel!
  @IBOutlet weak var team2Image: UIImageView!

  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var tableViewTeam1: UITableView!
  @IBOutlet weak var tableViewTeam2: UITableView!
  @IBOutlet weak var timeLabel: UILabel!
  init(
    viewModel: any DetailsViewModelProtocol
  ) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  private func setup() {
    setupUI()
    loadUI()
    bind()
    viewModel.fetch()
  }

  // MARK: - Bindings
  func bind() {
    self.viewModel.statePublisher
      .receive(on: RunLoop.main)
      .sink { [weak self] state in
        guard let self = self else { return }
        self.handleState(state: state)
      }
      .store(in: &cancellables)
  }

  private func handleState(state: DetailsState) {
    switch state {
    case .loading: loadingState()
    case .error(let errorMsg): handleError(msg: errorMsg)
    case .ready: readyState()
    }
  }

  // MARK: - UI
  private func setupTableView() {
    [tableViewTeam1, tableViewTeam2].forEach {
      $0.dataSource = self
      $0.delegate = self
    }
    tableViewTeam1.register(PlayerTableViewCell.self)
    tableViewTeam2.register(InvertedPlayerTableViewCell.self)

  }

  private func loadingState() { activityIndicator.startAnimating() }

  private func stopLoading() { activityIndicator.stopAnimating() }

  private func handleError(msg: String) {
    stopLoading()
    log.error("%@", msg)
    showAlert(
      title: "Erro",
      message: "Aconteceu um erro carregando os dados da API.",
      buttonTitle: "Tentar Novamente"
    ) { [weak self] _ in
      self?.viewModel.fetch()
    }
  }

  private func readyState() {
    stopLoading()
    [tableViewTeam1, tableViewTeam2].forEach { $0.reloadData() }
  }

  private func setupUI() {
    view.backgroundColor = UIColor.AppColors.appBg.color
    timeLabel.font = UIFont.font(of: .roboto, weight: .bold, size: 12)
    [team1Label, team2Label].forEach {
      $0.font = UIFont.font(of: .roboto, size: 10)
    }
    setupTableView()
  }

  private func loadUI() {
    title = viewModel.title
    timeLabel.text = viewModel.time
    team1Label.text = viewModel.team1
    team2Label.text = viewModel.team2
    
    handleTeam1Image()
    handleTeam2Image()
  }

  private func handleTeam1Image() {
    Task {
      guard let image = await viewModel.downloadTeam1Image() else {
        handleNoImage(imageView: team1Image, radius: 30)
        return
      }
      if Task.isCancelled {
        handleNoImage(imageView: team1Image, radius: 30)
        return
      }
      team1Image.image = image
    }
  }

  private func handleTeam2Image() {
    Task {
      guard let image = await viewModel.downloadTeam2Image() else {
        handleNoImage(imageView: team2Image, radius: 30)
        return
      }
      if Task.isCancelled {
        handleNoImage(imageView: team2Image, radius: 30)
        return
      }
      team2Image.image = image
    }
  }

  private func handleNoImage(imageView: UIImageView, radius: CGFloat) {
    imageView.backgroundColor = UIColor.AppColors.appGray.color
    imageView.layer.cornerRadius = radius
  }
}

extension DetailsViewController: UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int { viewModel.numberOfSections() }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let isTeam1 = tableView == tableViewTeam1
    return viewModel.numberOfRows(in: section, isTeam1: isTeam1)
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let isTeam1 = tableView == tableViewTeam1
    guard let player = viewModel.player(at: indexPath, isTeam1: isTeam1) else {
      return UITableViewCell()
    }
    if isTeam1 {
      let cell: PlayerTableViewCell? = tableView.dequeueReusableCell(forIndexPath: indexPath)
      guard let cell = cell else { return UITableViewCell() }
      cell.setup(with: player)
      return cell
    } else {
      let cell: InvertedPlayerTableViewCell? = tableView.dequeueReusableCell(forIndexPath: indexPath)
      guard let cell = cell else { return UITableViewCell() }
      cell.setup(with: player)
      return cell
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 86 }
}

extension DetailsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
