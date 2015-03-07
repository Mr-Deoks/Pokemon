//
//  Pokemon.swift
//  Combat
//
//  Created by Denis Aganin on 04.03.15.
//  Copyright (c) 2015 Denis Aganin. All rights reserved.
//

import Foundation
import UIKit

class Pokemon {
    var name = ""
    var health = 0
    var maxHealth = 0
    var image = UIImage(named: "")
    var type = ""
    var attacks: [Attack] = []
}

class ElectricPokemon: Pokemon {
    override var type: String {
        get {
            return "electric"
        }
        set {}
    }
}

class  WaterPokemon: Pokemon {
    override var type: String {
        get {
            return "Water"
        }
        set {}
    }
}

class GrassPokemon: Pokemon {
    override var type: String {
        get {
            return "Grass"
        }
        set {}
    }
}

class FirePokemon: Pokemon {
    override var type: String {
        get {
            return "Fire"
        }
        set {}
    }
}