//
//  HomePresenter.swift
//  Pokedex
//
//  Created by Felipe Leite on 05/11/22.
//

import Foundation

protocol HomePresenterDelegate: AnyObject {
    func listUpdated()
    func showLoading(_ isLoading: Bool)
}

class HomePresenter {
    
    private struct Consts {
        static let pageSize: Int = 50
    }

    // MARK: Properties

    private let api: ApiManager

    weak var delegate: HomePresenterDelegate?
    var isLoadingMore = false

    // MARK: Initialization
    
    init(api: ApiManager = .shared) {
        self.api = api
    }

    // MARK: Public methods

    func delegateDidLoad() {
        Task { await loadMore() }
    }

    func delegateWantsToLoadMore() {
        guard self.api.hasMore(), self.isLoadingMore == false else { return }

        self.isLoadingMore = true

        Task {
            await loadMore()
            self.isLoadingMore = false
        }
    }

    func numberOfPokemons() -> Int {
        return self.api.pokemons.count
    }

    func pokemon(atIndex index: Int) -> Pokemon {
        return self.api.pokemon(atIndex: index)
    }
    
    // MARK: Private methods

    private func loadMore() async {
        self.delegate?.showLoading(true)

        await self.api.loadNext()

        self.delegate?.showLoading(false)
        self.delegate?.listUpdated()
    }
}
