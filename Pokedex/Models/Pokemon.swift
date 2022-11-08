//
//  Pokemon.swift
//  Pokedex
//
//  Created by Felipe Leite on 05/11/22.
//

import Foundation

struct PokemonSprites {

    var front: String?

}

extension PokemonSprites: Hashable {

    static func == (lhs: PokemonSprites, rhs: PokemonSprites) -> Bool {
        return (lhs.front?.hashValue ?? 0) == (rhs.front?.hashValue ?? 0)
    }

}

// MARK: -

struct PokemonType {

    var name: String?

}

extension PokemonType: Hashable {

    static func == (lhs: PokemonType, rhs: PokemonType) -> Bool {
        return (lhs.name?.hashValue ?? 0) == (rhs.name?.hashValue ?? 0)
    }

}

// MARK: -

struct PokemonStat {

    var name: String?
    var baseStat: Int?

}

extension PokemonStat: Hashable {

    static func == (lhs: PokemonStat, rhs: PokemonStat) -> Bool {
        return (lhs.name?.hashValue ?? 0) == (rhs.name?.hashValue ?? 0)
            && (lhs.baseStat ?? 0) == (rhs.baseStat ?? 0)
    }

}

// MARK: -

struct Pokemon {

    var id: Int?
    let name: String
    var baseExperience: Int?
    var height: Int?
    var weight: Int?
    var isDefault: Bool?
    var spries: PokemonSprites?
    var types: [ PokemonType ]?
    var stats: [ PokemonStat ]?
    var isLoaded = false

    var fullIdentifier: String {
        let id = String(format: "%03d", self.id ?? 0)
        return "#\(id) \(self.name.capitalized)"
    }

}

extension Pokemon: Hashable {

    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        return lhs.name.hashValue == rhs.name.hashValue
            && lhs.isLoaded == rhs.isLoaded
    }

}
