//
//  HomeViewController.swift
//  Pokedex
//
//  Created by Felipe Leite on 05/11/22.
//

import UIKit
import SkeletonView

class HomeViewController: ViewController {

    private struct Consts {
        static let estimatedRowHeight: CGFloat = 80.0
    }
    
    // MARK: Properties

    var presenter: HomePresenter
    private var dataSource: UITableViewDiffableDataSource<Int, Pokemon>?

    // MARK: Views

    @IBOutlet weak var tableView: UITableView!

    lazy var searchController = UISearchController()

    // MARK: Initialization

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.presenter = HomePresenter()

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        self.presenter = HomePresenter()

        super.init(coder: coder)
    }

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.presenter.delegateDidLoad()
    }
    
    // MARK: Helpers

    private func setup() {
        self.dataSource = makeDataSource()
        self.presenter.delegate = self
        self.tableView?.delegate = self
        self.tableView?.dataSource = self.dataSource
        self.tableView?.rowHeight = Consts.estimatedRowHeight
        self.searchController.searchResultsUpdater = self
        
        self.navigationItem.searchController = searchController
    }

    private func makeDataSource() -> UITableViewDiffableDataSource<Int, Pokemon> {
        return UITableViewDiffableDataSource(tableView: self.tableView) { tableView, indexPath, pokemon in
            if indexPath.row < self.presenter.numberOfPokemons() {
                return HomePokemonCell.dequeueReusableCell(from: tableView, pokemon: pokemon, for: indexPath)
            }

            return HomePokemonCell.dequeueReusablePlaceholderCell(from: tableView, for: indexPath)
        }
    }

}

// MARK: -

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let pokemon = self.presenter.pokemon(atIndex: indexPath.row)
        let vc = PokemonDetailsViewController(pokemon: pokemon)

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("--> should load more", indexPath.section == 1)
        guard indexPath.section == 1 else { return }
        self.presenter.delegateWantsToLoadMore()
    }
        
}

// MARk: -

extension HomeViewController: HomePresenterDelegate {

    func listUpdated() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Pokemon>()
        snapshot.appendSections([ 0, 1 ])

        var items = self.presenter.pokemons()

        if self.presenter.isLoading {
            for _ in 0 ..< 10 {
                items.append(Pokemon(name: UUID().uuidString))
            }
        }

        snapshot.appendItems(items, toSection: 0)
        
        if self.presenter.hasMore() {
            snapshot.appendItems([ Pokemon(name: UUID().uuidString) ], toSection: 1)
        }

        dataSource?.apply(snapshot, animatingDifferences: false)
    }

}

// MARK: -

extension HomeViewController: UISearchControllerDelegate, UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let search = searchController.searchBar.text
        self.presenter.delegateDidUpdateSearch(search)
    }

}
