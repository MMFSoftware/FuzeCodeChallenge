//
//  HomeViewController.swift
//  FuseCodeChallenge
//
//  Created by Felipe Oliveira on 12/10/22.
//

import Combine
import UIKit

class HomeViewController: UIViewController, AlertsProtocol {
  var cancellables: Set<AnyCancellable> = []
  private var viewModel: any HomeViewModelProtocol

  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var tableView: UITableView!

  init(
    viewModel: any HomeViewModelProtocol = HomeViewModel()
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
    setupTableView()
    bind()
    viewModel.refresh()
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

  private func handleState(state: HomeState) {
    switch state {
    case .loading: loadingState()
    case .error(let errorMsg): handleError(msg: errorMsg)
    case .ready: readyState()
    }
  }

  // MARK: - UI
  private func setupUI() {
    title = "Partidas"
    navigationItem.style = .editor
  }

  private func setupTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(HomeTableViewCell.self)
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
      self?.viewModel.refresh()
    }
  }

  private func readyState() {
    stopLoading()
    tableView.reloadData()
  }
}

extension HomeViewController: UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    viewModel.numberOfSections() }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.numberOfRows(in: section) }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let match = viewModel.match(at: indexPath) else {
      return UITableViewCell()
    }

    let cell: HomeTableViewCell? = tableView.dequeueReusableCell(forIndexPath: indexPath)
    guard let cell = cell else { return UITableViewCell() }
    cell.setup(with: match)
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 200 }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    viewModel.paginate(with: indexPath)
  }
}

extension HomeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    guard let match = viewModel.match(at: indexPath) else { return }

    let detailsVM = DetailsViewModel(match: match)
    let detailsVC = DetailsViewController(viewModel: detailsVM)
    navigationController?.pushViewController(detailsVC, animated: true)

  }
}
