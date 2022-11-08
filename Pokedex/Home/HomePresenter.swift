//
//  HomePresenter.swift
//  Pokedex
//
//  Created by Felipe Leite on 05/11/22.
//

import Foundation

protocol HomePresenterDelegate: AnyObject {
    func listUpdated()
    func showLoading(_ show: Bool)
}

class HomePresenter {
    
    private struct Consts {
        static let pageSize: Int = 50
    }

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

    func numberOfPokemons() -> Int {
        return self.api.numberOfPokemons(filter: self.search)
    }

    func pokemon(atIndex index: Int) -> Pokemon {
        return self.api.pokemon(atIndex: index, filter: self.search)
    }
    
    // MARK: Private methods

    private func loadMore() {
        guard self.isLoading == false else { return }

        self.isLoading = true
        
        Task {
            await MainActor.run {
                self.delegate?.showLoading(true)
            }

            await self.api.loadNext()

            await MainActor.run {
                self.isLoading = false
                self.delegate?.showLoading(false)
                self.delegate?.listUpdated()
            }
        }
    }
}
