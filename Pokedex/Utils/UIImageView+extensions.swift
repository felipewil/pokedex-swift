//
//  UIImageView+extensions.swift
//  Pokedex
//
//  Created by Felipe Leite on 05/11/22.
//

import UIKit

extension UIImageView {

    func loadPokemon(_ pokemon: Pokemon) async {
        guard
            let sprite = pokemon.spries?.front,
            let url = URL(string: sprite) else { return }

        let response = try? await URLSession.shared.data(from: url)

        guard let data = response?.0 else { return }

        DispatchQueue.main.async { [ weak self ] in
            self?.image = UIImage(data: data)
        }
    }

}
