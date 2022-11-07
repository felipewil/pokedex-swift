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
    var search: String?

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

    func delegateDidUpdateSearch(_ search: String?) {
        guard self.search ?? "" != search?.lowercased() ?? "" else { return }
        self.search = search?.lowercased()
        self.delegate?.listUpdated()
    }

    func numberOfPokemons() -> Int {
        return self.api.numberOfPokemons(filter: self.search)
    }

    func pokemon(atIndex index: Int) -> Pokemon {
        return self.api.pokemon(atIndex: index, filter: self.search)
    }
    
    // MARK: Private methods

    private func loadMore() async {
        self.delegate?.showLoading(true)

        await self.api.loadNext()

        self.delegate?.showLoading(false)
        self.delegate?.listUpdated()
    }
}
