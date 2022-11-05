//
//  TypeStackView.swift
//  Pokedex
//
//  Created by Felipe Leite on 05/11/22.
//

import UIKit

class TypeStackView: UIStackView {

    private struct Consts {
        static let fontSize: CGFloat = 13.0
    }

    // MARK: Public helpers
    
    func load(types: [ PokemonType ]) {
        self.arrangedSubviews.forEach { $0.removeFromSuperview() }

        types.forEach { type in
            let label = UILabel()
            label.text = type.name?.capitalized
            label.font = .systemFont(ofSize: Consts.fontSize, weight: .semibold)
            label.textColor = self.foregroundColor(for: type)
            label.translatesAutoresizingMaskIntoConstraints = false
            
            let wrapper = UIView()
            wrapper.addSubview(label)
            wrapper.layer.cornerRadius = 10.0
            wrapper.backgroundColor = self.backgroundColor(for: type)
            wrapper.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: 8.0),
                label.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: 4.0),
                label.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor, constant: -8.0),
                label.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor, constant: -4.0),
            ])
            
            self.addArrangedSubview(wrapper)
        }
    }
    
    // MARK: Helpers
    
    private func foregroundColor(for type: PokemonType) -> UIColor? {
        guard let name = type.name else { return .clear }

        switch name {
        case "normal": return .white
        case "fire": return .white
        case "water": return .white
        case "electric": return .white
        case "grass": return .white
        case "ice": return .white
        case "fighting": return .white
        case "poison": return .white
        case "ground": return .white
        case "flying": return .white
        case "psychic": return .white
        case "bug": return .white
        case "rock": return .white
        case "ghost": return .white
        case "dragon": return .white
        case "dark": return .white
        case "steel": return .white
        case "fairy": return .white
        default: return .clear
        }
    }

    private func backgroundColor(for type: PokemonType) -> UIColor? {
        guard let name = type.name else { return .clear }

        switch name {
        case "normal": return UIColor(rgb: 0xA8A77A)
        case "fire": return UIColor(rgb: 0xEE8130)
        case "water": return UIColor(rgb: 0x6390F0)
        case "electric": return UIColor(rgb: 0xF7D02C)
        case "grass": return UIColor(rgb: 0x7AC74C)
        case "ice": return UIColor(rgb: 0x96D9D6)
        case "fighting": return UIColor(rgb: 0xC22E28)
        case "poison": return UIColor(rgb: 0xA33EA1)
        case "ground": return UIColor(rgb: 0xE2BF65)
        case "flying": return UIColor(rgb: 0xA98FF3)
        case "psychic": return UIColor(rgb: 0xF95587)
        case "bug": return UIColor(rgb: 0xA6B91A)
        case "rock": return UIColor(rgb: 0xB6A136)
        case "ghost": return UIColor(rgb: 0x735797)
        case "dragon": return UIColor(rgb: 0x6F35FC)
        case "dark": return UIColor(rgb: 0x705746)
        case "steel": return UIColor(rgb: 0xB7B7CE)
        case "fairy": return UIColor(rgb: 0xD685AD)
        default: return .clear
        }
    }
    
}
