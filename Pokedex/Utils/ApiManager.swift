//
//  PokemonManager.swift
//  Pokedex
//
//  Created by Felipe Leite on 05/11/22.
//

import Foundation
import PokemonAPI

class ApiManager {

    private struct Consts {
        static let pageSize: Int = 25
    }

    // MARK: Properties
    
    static let shared = ApiManager()

    private let api: PokemonAPI
    private var currentPage: PKMPagedObject<PKMPokemon>?

    weak var delegate: HomePresenterDelegate?
    var pokemons: [ Pokemon ] = []
    var isLoading = false

    // MARK: Initialization
    
    init(api: PokemonAPI = PokemonAPI()) {
        self.api = api
    }

    // MARK: Public methods

    func loadNext() async {
        guard self.isLoading == false else { return }

        weak var weakSelf = self
        weakSelf?.isLoading = true

        if let page = weakSelf?.currentPage {
            weakSelf?.currentPage = try? await self.api.pokemonService.fetchPokemonList(paginationState: .continuing(page, .next))
        } else {
            weakSelf?.currentPage = try? await self.api.pokemonService.fetchPokemonList(paginationState: .initial(pageLimit: Consts.pageSize))
        }
        
        if let results = weakSelf?.currentPage?.results as? [ PKMNamedAPIResource ] {
            results.forEach { result in
                guard let name = result.name else { return }
                self.pokemons.append(Pokemon(name: name))
            }
        }

        weakSelf?.isLoading = false
    }
    
    func pokemon(atIndex index: Int) -> Pokemon {
        return self.pokemons[index]
    }

    func loadPokemon(_ pokemon: Pokemon) async -> Pokemon? {
        guard
            let result = try? await self.api.pokemonService.fetchPokemon(pokemon.name),
            let name = result.name,
            let index = self.pokemons.firstIndex(where: { $0.name == name }) else { return nil }

        let sprites = PokemonSprites(front: result.sprites?.frontDefault)
        let types = result.types?.compactMap { type -> PokemonType? in
            guard let name = type.type?.name else { return nil }
            return PokemonType(name: name)
        }
        let pokemon = Pokemon(id: result.id,
                              name: name,
                              baseExperience: result.baseExperience,
                              height: result.height,
                              isDefault: result.isDefault,
                              spries: sprites,
                              types: types,
                              isLoaded: true)
    
        self.pokemons[index] = pokemon
        return pokemon
    }
    
    // MARK: Private methods

}
