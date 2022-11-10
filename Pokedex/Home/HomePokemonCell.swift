//
//  HomePokemonCell.swift
//  Pokedex
//
//  Created by Felipe Leite on 05/11/22.
//

import UIKit
import SkeletonView

class HomePokemonCell: UITableViewCell {

    private struct Consts {
        static let titleFontSize: CGFloat = 20.0
        static let typeFontSize: CGFloat = 13.0
    }

    // MARK: Properties

    static let reusableIdentifier = "HomePokemonCell"
    private var presenter = HomePokemonCellPresenter()
    private var isPlaceholder = false
    private var pokemon: Pokemon?
    
    // MARK: Views

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var spriteImageView: UIImageView!
    @IBOutlet weak var typesStack: TypeStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }

    // MARK: Public methods
    
    static func dequeueReusableCell(from tableView: UITableView,
                                    pokemon: Pokemon,
                                    for indexPath: IndexPath) -> HomePokemonCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as! HomePokemonCell
        
        if cell.pokemon?.name != pokemon.name {
            cell.pokemon = pokemon
            cell.isPlaceholder = false

            cell.clean()
            
            cell.presenter.delegate = cell
            cell.presenter.delegateDidLoad(with: pokemon)
        }

        return cell
    }
    
    static func dequeueReusablePlaceholderCell(from tableView: UITableView,
                                               for indexPath: IndexPath) -> HomePokemonCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as! HomePokemonCell

        cell.isPlaceholder = true
        cell.showLoading(true)
        cell.spriteImageView?.showAnimatedGradientSkeleton()

        return cell
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.spriteImageView.image = nil
        self.titleLabel.text = nil
        self.typesStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    // MARK: Helpers
    
    private func setup() {
        self.isSkeletonable = true
        self.titleLabel.isSkeletonable = true
        self.spriteImageView.isSkeletonable = true
        self.typesStack.isSkeletonable = true

        self.titleLabel.font = .systemFont(ofSize: Consts.titleFontSize,
                                            weight: .semibold)
        self.typesStack.distribution = .fillProportionally
        self.typesStack.spacing = 8.0
    }
    
    private func clean() {
        self.spriteImageView.image = nil
        self.titleLabel.text = nil
    }

}

// MARK: -

extension HomePokemonCell: HomePokemonCellPresenterDelegate {

    func showLoading(_ show: Bool) {
        if show {
            self.titleLabel?.showAnimatedGradientSkeleton()
            self.typesStack?.showLoading()
            self.spriteImageView?.showAnimatedGradientSkeleton()
        } else {
            self.titleLabel?.hideSkeleton()
            self.spriteImageView?.hideSkeleton()
        }
    }

    func show(_ pokemon: Pokemon) {
        guard self.pokemon?.name == pokemon.name else { return }

        self.titleLabel?.text = pokemon.fullIdentifier
        self.typesStack?.load(types: pokemon.types ?? [])

        Task { await loadSprite(for: pokemon) }
    }
    
    // MARK: Helpers
    
    private func loadSprite(for pokemon: Pokemon) async {
        guard
            let sprite = pokemon.spries?.front,
            let url = URL(string: sprite) else { return }

        let response = try? await URLSession.shared.data(from: url)

        guard let data = response?.0 else { return }

        await MainActor.run { [ weak self ] in
            guard self?.pokemon?.name == pokemon.name else { return }
            self?.spriteImageView?.image = UIImage(data: data)
        }
    }

}
