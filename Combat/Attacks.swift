//
//  Attacks.swift
//  Combat
//
//  Created by Denis Aganin on 04.03.15.
//  Copyright (c) 2015 Denis Aganin. All rights reserved.
//

import Foundation

class Attack {
    var name = ""
    var damage = 0
    var hitChance = 0
    var type = ""
    
    func attackAction() {
        
    }
}

class NormalAttack: Attack {
    override var type: String {
        get {
            return "Normal"
        }
        set {}
    }
}

class ElectricAttack: Attack {
    override var type: String {
        get {
            return "Electric"
        }
        set {}
    }
}

class FireAttack: Attack {
    override var type: String {
        get {
            return "Fire"
        }
        set {}
    }
}

class WaterAttack: Attack {
    override var type: String {
        get {
            return "Normal"
        }
        set {}
    }
}

class GrassAttack: Attack {
    override var type: String {
        get {
            return "Grass"
        }
        set {}
    }
}