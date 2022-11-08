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
    private(set) var pokemons: [ Pokemon ] = []

    weak var delegate: HomePresenterDelegate?
    var isLoading = false

    // MARK: Initialization
    
    init(api: PokemonAPI = PokemonAPI()) {
        self.api = api
    }

    // MARK: Public methods

    /// Loads the next batch of pokemons.
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

    /// Whether there are more pokemons to be loaded.
    func hasMore() -> Bool {
        return self.currentPage?.hasNext ?? false
    }

    /// Returns all loaded pokemons with filter applied.
    func pokemons(filter: String? = nil) -> [ Pokemon ] {
        let pokemons = self.pokemons
        
        if let filter, !filter.isEmpty {
            return pokemons
                .filter { $0.name.lowercased().contains(filter) }
        }
        
        return pokemons
    }

    /// Returns a `Pokemon` at the given index with filter applied.
    func pokemon(atIndex index: Int, filter: String? = nil) -> Pokemon {
        return self.pokemons(filter: filter)[index]
    }

    /// Load details for the given Pokemon.
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
        let stats = result.stats?.compactMap { stat -> PokemonStat? in
            guard let name = stat.stat?.name else { return nil }
            return PokemonStat(name: name, baseStat: stat.baseStat)
        }
        let pokemon = Pokemon(id: result.id,
                              name: name,
                              baseExperience: result.baseExperience,
                              height: result.height,
                              weight: result.weight,
                              isDefault: result.isDefault,
                              spries: sprites,
                              types: types,
                              stats: stats,
                              isLoaded: true)
    
        self.pokemons[index] = pokemon
        return pokemon
    }
    
    // MARK: Private methods

}
