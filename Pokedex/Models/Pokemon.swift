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

struct Pokemon {

    var id: Int?
    let name: String
    var baseExperience: Int?
    var height: Int?
    var isDefault: Bool?
    var weight: Int?
    var spries: PokemonSprites?
    var types: [ PokemonType ]?
    var isLoaded = false

}
