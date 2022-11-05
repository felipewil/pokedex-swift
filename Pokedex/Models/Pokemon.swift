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

struct PokemonType {

    var name: String?

}

struct PokemonStat {

    var name: String?
    var baseStat: Int?

}

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
