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
        static let typeFontSize: CGFloat = 17.0
    }

    // MARK: Properties
    
    static let reusableIdentifier = "HomePokemonCell"
    var presenter = HomePokemonCellPresenter()
    
    // MARK: Views

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var spriteImageView: UIImageView?
    @IBOutlet weak var typesStack: UIStackView?

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
        self.titleLabel?.font = .systemFont(ofSize: Consts.titleFontSize)
        self.typesStack?.distribution = .fillProportionally
        self.typesStack?.alignment = .leading
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
        let id = String(format: "%03d", pokemon.id ?? 0)
        self.titleLabel?.text = "\(id) \(pokemon.name.capitalized)"

        self.typesStack?.arrangedSubviews.forEach { $0.removeFromSuperview() }
        pokemon.types?.forEach { type in
            let label = UILabel()
            label.text = type.name?.capitalized
            label.font = .systemFont(ofSize: Consts.typeFontSize)
            label.translatesAutoresizingMaskIntoConstraints = false
            
            let wrapper = UIView()
            wrapper.addSubview(label)
            wrapper.layer.cornerRadius = 10.0
            wrapper.backgroundColor = self.backgroundColor(for: type)
            wrapper.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: 8.0),
                label.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: 4.0),
                label.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor, constant: -8.0),
                label.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor, constant: -4.0),
            ])
            
            self.typesStack?.addArrangedSubview(wrapper)
        }

        Task { await self.loadSprite(pokemon: pokemon) }
    }

    // MARK: Helpers
    
    private func loadSprite(pokemon: Pokemon) async {
        guard
            let sprite = pokemon.spries?.front,
            let url = URL(string: sprite) else { return }

        let response = try? await URLSession.shared.data(from: url)

        guard let data = response?.0 else { return }

        DispatchQueue.main.async {
            self.spriteImageView?.image = UIImage(data: data)
        }
    }

    private func backgroundColor(for type: PokemonType) -> UIColor? {
        guard let name = type.name else { return .clear }

        switch name {
        case "grass": return .green
        case "fire": return .green
        default: return .clear
        }
    }

}
