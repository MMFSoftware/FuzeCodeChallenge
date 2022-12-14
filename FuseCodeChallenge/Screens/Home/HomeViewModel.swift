//
//  HomeViewModel.swift
//  FuseCodeChallenge
//
//  Created by Felipe Oliveira on 12/10/22.
//

import Combine
import UIKit

enum HomeState: Equatable {
  case error(String)
  case loading
  case ready

  static func == (lhs: HomeState, rhs: HomeState) -> Bool {
    switch (lhs, rhs) {
    case (.loading, .loading): return true
    case (.error, .error): return true
    case (.ready, .ready): return true
    default: return false
    }
  }
}

protocol HomeViewModelProtocol {
  var statePublisher: Published<HomeState>.Publisher { get }
  func numberOfSections() -> Int
  func numberOfRows(in section: Int) -> Int
  func match(at index: IndexPath) -> PandascoreMatch?
  func refresh()
  func paginate(with indexPath: IndexPath)
}

class HomeViewModel: HomeViewModelProtocol {
  var statePublisher: Published<HomeState>.Publisher { $state }
  @Published var state: HomeState = .loading

  private let pandascoreAPI: PandascoreAPIProtocol
  private var shouldPaginate = true
  private var matches: [PandascoreMatch]
  private var currentPage: Int = 1
  private var isLoading: Bool = false
  init(
    pandascoreAPI: PandascoreAPIProtocol = PandascoreAPI()
  ) {
    self.pandascoreAPI = pandascoreAPI
    self.matches = []
  }

  func refresh() {
    state = .loading
    fetch()
  }

  private func fetch() {
    Task {
      do {
        isLoading = true
        let newMatches = try await pandascoreAPI.fetchGames(page: currentPage)
        matches += newMatches
        shouldPaginate = !newMatches.isEmpty
        state = .ready
        isLoading = false
      } catch {
        state = .error(error.localizedDescription)
        isLoading = false
      }
    }
  }

  /// Paginate the data if needed
  /// - Parameter indexPath: the indexPath of the current place in the tableView
  func paginate(with indexPath: IndexPath) {
    guard needsPaginate(on: indexPath) else { return }
    currentPage += 1
    fetch()
  }

  func needsPaginate(on indexPath: IndexPath) -> Bool {
    guard shouldPaginate, !isLoading else { return false }
    return indexPath.row >= matches.count - 5
  }

  func numberOfSections() -> Int { 1 }

  func numberOfRows(in section: Int) -> Int { matches.count }

  func match(at index: IndexPath) -> PandascoreMatch? { matches[safe: index.row] }
}
