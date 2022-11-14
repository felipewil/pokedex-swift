//
//  HomePresenter.swift
//  Pokedex
//
//  Created by Felipe Leite on 05/11/22.
//

import Foundation

protocol HomePresenterDelegate: AnyObject {
    func listUpdated()
}

class HomePresenter {

    // MARK: Properties

    private let api: ApiManager

    weak var delegate: HomePresenterDelegate?
    private(set) var isLoading = false
    private(set) var search: String?

    // MARK: Initialization
    
    init(api: ApiManager = .shared) {
        self.api = api
    }

    // MARK: Public methods

    func delegateDidLoad() {
        loadMore()
    }

    func delegateWantsToLoadMore() {
        guard self.api.hasMore() else { return }
        loadMore()
    }

    func delegateDidUpdateSearch(_ search: String?) {
        guard self.search ?? "" != search?.lowercased() ?? "" else { return }
        self.search = search?.lowercased()
        self.delegate?.listUpdated()
    }

    /// Returns the current number of loaded pokemons with filter applied.
    func numberOfPokemons() -> Int {
        return self.api.pokemons(filter: self.search).count
    }

    /// Returns a `Pokemon` at the given index.
    func pokemon(atIndex index: Int) -> Pokemon {
        return self.api.pokemon(atIndex: index, filter: self.search)
    }

    /// Returns all loaded pokemons with filter applied.
    func pokemons() -> [ Pokemon ] {
        return self.api.pokemons(filter: self.search)
    }

    /// Whether there are more pokemons to be loaded.
    func hasMore() -> Bool {
        return self.api.hasMore()
    }

    // MARK: Private methods

    private func loadMore() {
        guard self.isLoading == false else { return }

        self.isLoading = true

        Task {
            await self.api.loadNext()

            await MainActor.run {
                self.isLoading = false
                self.delegate?.listUpdated()
            }
        }
    }
}
