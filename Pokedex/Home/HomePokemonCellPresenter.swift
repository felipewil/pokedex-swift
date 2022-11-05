//
//  HomePokemonCellPresenter.swift
//  Pokedex
//
//  Created by Felipe Leite on 05/11/22.
//

import Foundation

protocol HomePokemonCellPresenterDelegate: AnyObject {
    func showLoading(_ show: Bool)
    func show(_ pokemon: Pokemon)
}

class HomePokemonCellPresenter {

    // MARK: Properties
    
    weak var delegate: HomePokemonCellPresenterDelegate?
    let api: ApiManager
    
    // MARK: Initialization
    
    init(api: ApiManager = .shared) {
        self.api = api
    }

    // MARK: Public method
    
    func delegateDidLoad(with pokemon: Pokemon) {
        self.handle(pokemon)
    }

    // MARK: Helpers
    
    private func handle(_ pokemon: Pokemon) {
        if pokemon.isLoaded {
            self.delegate?.show(pokemon)
        } else {
            Task {
                self.delegate?.showLoading(true)
                let pokemon = await self.api.loadPokemon(pokemon)
                self.delegate?.showLoading(false)

                guard let pokemon else { return }
                
                await MainActor.run {
                    self.delegate?.show(pokemon)
                }
            }
        }
    }

}
