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

    // MARK: Views

    @IBOutlet weak var tableView: UITableView?

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
        self.presenter.delegate = self
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.rowHeight = Consts.estimatedRowHeight
        self.searchController.searchResultsUpdater = self
        
        self.navigationItem.searchController = searchController
    }

}

// MARK: -

extension HomeViewController: UITableViewDelegate, SkeletonTableViewDataSource {

    func numberOfSections(in skeletonView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.numberOfPokemons() + (self.presenter.isLoading ? 10 : 0)
    }

    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return HomePokemonCell.reusableIdentifier
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < self.presenter.numberOfPokemons() {
            let pokemon = self.presenter.pokemon(atIndex: indexPath.row)
            return HomePokemonCell.dequeueReusableCell(from: tableView, pokemon: pokemon, for: indexPath)
        }

        return HomePokemonCell.dequeueReusablePlaceholderCell(from: tableView, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let pokemon = self.presenter.pokemon(atIndex: indexPath.row)
        let vc = PokemonDetailsViewController(pokemon: pokemon)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row >= self.presenter.numberOfPokemons() - 10 else { return }
        self.presenter.delegateWantsToLoadMore()
    }
        
}

// MARk: -

extension HomeViewController: HomePresenterDelegate {

    func listUpdated() {
        self.tableView?.reloadData()
    }

    func showLoading(_ show: Bool) {
        
    }

}

// MARK: -

extension HomeViewController: UISearchControllerDelegate, UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let search = searchController.searchBar.text
        self.presenter.delegateDidUpdateSearch(search)
    }

}
