//
//  UIImageView+extensions.swift
//  Pokedex
//
//  Created by Felipe Leite on 05/11/22.
//

import UIKit
import SkeletonView

extension UIImageView {

    /// Loads a sprite from the given `Pokemon`.
    func loadPokemon(_ pokemon: Pokemon) async {
        guard
            let sprite = pokemon.spries?.front,
            let url = URL(string: sprite) else { return }

        weak var weakSelf = self

        let response = try? await URLSession.shared.data(from: url)

        guard let data = response?.0 else { return }

        await MainActor.run {
            weakSelf?.image = UIImage(data: data)
        }
    }

}
