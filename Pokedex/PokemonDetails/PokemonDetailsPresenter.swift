//
//  PokemonDetailsPresenter.swift
//  Pokedex
//
//  Created by Felipe Leite on 05/11/22.
//

import Foundation

protocol PokemonDetailsPresenterDelegate: AnyObject {
    func show(_ pokemon: Pokemon)
}

class PokemonDetailsPresenter {
    
    // MARK: Properties

    private var pokemon: Pokemon
    weak var delegate: PokemonDetailsPresenterDelegate?
    
    // MARK: Initialization

    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    // MARK: Public methods
    
    func delegateDidLoad() {
        self.delegate?.show(self.pokemon)
    }

}
