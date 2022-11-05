//
//  HomeViewController.swift
//  Pokedex
//
//  Created by Felipe Leite on 05/11/22.
//

import UIKit

class HomeViewController: ViewController {

    // MARK: Properties

    var presenter: HomePresenter

    // MARK: Views

    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?

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
    }

}

// MARK: -

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.numberOfPokemons()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokemon = self.presenter.pokemon(atIndex: indexPath.row)
        return HomePokemonCell.dequeueReusableCell(from: tableView, pokemon: pokemon, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let pokemon = self.presenter.pokemon(atIndex: indexPath.row)
        let vc = PokemonDetailsViewController(pokemon: pokemon)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
}

// MARk: -

extension HomeViewController: HomePresenterDelegate {

    func listUpdated() {
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
    
    func showLoading(_ isLoading: Bool) {
        DispatchQueue.main.async {
            if isLoading {
                self.activityIndicator?.startAnimating()
            } else {
                self.activityIndicator?.stopAnimating()
            }
        }
    }

}
