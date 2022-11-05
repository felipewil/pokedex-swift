//
//  HomePokemonCell.swift
//  Pokedex
//
//  Created by Felipe Leite on 05/11/22.
//

import UIKit

class HomePokemonCell: UITableViewCell {

    private struct Consts {
        static let titleFontSize: CGFloat = 20.0
        static let typeFontSize: CGFloat = 13.0
    }

    // MARK: Properties
    
    static let reusableIdentifier = "HomePokemonCell"
    var presenter = HomePokemonCellPresenter()
    
    // MARK: Views

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var spriteImageView: UIImageView?
    @IBOutlet weak var typesStack: TypeStackView?

    // MARK: Public methods
    
    static func dequeueReusableCell(from tableView: UITableView,
                                    pokemon: Pokemon,
                                    for indexPath: IndexPath) -> HomePokemonCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as! HomePokemonCell

        cell.setup()
        cell.presenter.delegate = cell
        cell.presenter.delegateDidLoad(with: pokemon)

        return cell
    }
    
    // MARK: Helpers
    
    private func setup() {
        self.titleLabel?.font = .systemFont(ofSize: Consts.titleFontSize,
                                            weight: .semibold)
        self.typesStack?.distribution = .fillProportionally
        self.typesStack?.spacing = 8.0
    }

}

// MARK: -

extension HomePokemonCell: HomePokemonCellPresenterDelegate {
    
    func showLoading(_ show: Bool) {
        DispatchQueue.main.async {
            if show {
                self.activityIndicator?.startAnimating()
            } else {
                self.activityIndicator?.stopAnimating()
            }
        }
    }

    func show(_ pokemon: Pokemon) {
        self.titleLabel?.text = pokemon.fullIdentifier
        self.typesStack?.load(types: pokemon.types ?? [])

        Task { await self.spriteImageView?.loadPokemon(pokemon) }
    }

}
