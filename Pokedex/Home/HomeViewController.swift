//
//  HomeViewController.swift
//  Pokedex
//
//  Created by Felipe Leite on 05/11/22.
//

import UIKit
import SkeletonView

enum Layout {
    case table
    case collection
    
    var image: String {
        switch self {
        case .table: return "list.dash"
        case .collection: return "square.grid.2x2"
        }
    }
}

class HomeViewController: ViewController {

    private struct Consts {
        static let estimatedTableRowHeight: CGFloat = 96.0
        static let estimatedCollectionRowHeight: CGFloat = 170.0
    }
    
    // MARK: Properties

    var presenter: HomePresenter
    private var currentLayout = Layout.table
    private var dataSource: UICollectionViewDiffableDataSource<Int, Pokemon>?

    lazy private var listLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()

        

        return layout
    }()

    // MARK: Views

    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var changeLayoutBarButtonItem: UIBarButtonItem!

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
        self.listLoading()
    }

    // MARK: Actions

    @IBAction func updateLayout(_ sender: UIBarButtonItem) {
        UIView.animate(withDuration: 0.2, delay: 0.0) {
            self.collectionView.alpha = 0
        }
        
        UIView.animate(withDuration: 0.15, delay: 0.0, animations: {
            self.collectionView.alpha = 0
        }, completion: {_ in
            switch self.currentLayout {
            case .table:
                self.currentLayout = .collection
                self.changeLayoutBarButtonItem.image = UIImage(systemName: Layout.table.image)
            case .collection:
                self.currentLayout = .table
                self.changeLayoutBarButtonItem.image = UIImage(systemName: Layout.collection.image)
            }

            self.collectionView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()

            UIView.animate(withDuration: 0.2, delay: 0.0) {
                self.collectionView.alpha = 1.0
            }
        })
    }

    // MARK: Helpers
    
    private func setup() {
        self.dataSource = makeDataSource()
        self.presenter.delegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self.dataSource

        self.searchController.searchResultsUpdater = self
        self.changeLayoutBarButtonItem.image = UIImage(systemName: Layout.collection.image)
        
        self.navigationItem.searchController = searchController
    }
    
    private func makeDataSource() -> UICollectionViewDiffableDataSource<Int, Pokemon> {
        return UICollectionViewDiffableDataSource(collectionView: self.collectionView) { collectionView, indexPath, pokemon in
            if indexPath.row < self.presenter.numberOfPokemons() {
                return HomePokemonCell.dequeueReusableCell(from: collectionView,
                                                           layout: self.currentLayout,
                                                           pokemon: pokemon,
                                                           for: indexPath)
            }

            return HomePokemonCell.dequeueReusablePlaceholderCell(from: collectionView,
                                                                  for: indexPath)
        }
    }

}

// MARK: -

extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard indexPath.section == 0 else { return }

        let pokemon = self.presenter.pokemon(atIndex: indexPath.row)
        let vc = PokemonDetailsViewController(pokemon: pokemon)

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch currentLayout {
        case .collection:
            return CGSize(width: collectionView.bounds.width * 0.5 - 8,
                          height: Consts.estimatedCollectionRowHeight)
        case .table:
            return CGSize(width: collectionView.bounds.width,
                          height: Consts.estimatedTableRowHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard indexPath.section == 1, indexPath.row == 0 else { return }
        self.presenter.delegateWantsToLoadMore()
    }

}

// MARk: -

extension HomeViewController: HomePresenterDelegate {

    func listUpdated() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Pokemon>()
        snapshot.appendSections([ 0, 1 ])

        snapshot.appendItems(self.presenter.pokemons(), toSection: 0)
        
        if self.presenter.hasMore() {
            snapshot.appendItems([
                Pokemon(name: UUID().uuidString),
                Pokemon(name: UUID().uuidString),
                Pokemon(name: UUID().uuidString),
                Pokemon(name: UUID().uuidString),
                Pokemon(name: UUID().uuidString)
            ], toSection: 1)
        }

        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    // MARK: Helpers
    
    private func listLoading() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Pokemon>()
        snapshot.appendSections([ 0 ])

        var items: [ Pokemon ] = []

        if self.presenter.isLoading {
            for _ in 0 ..< 10 {
                items.append(Pokemon(name: UUID().uuidString))
            }
        }

        snapshot.appendItems(items, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

}

// MARK: -

extension HomeViewController: UISearchControllerDelegate, UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let search = searchController.searchBar.text
        self.presenter.delegateDidUpdateSearch(search)
    }

}
