//
//  ViewController.swift
//  Combat
//
//  Created by Denis Aganin on 04.03.15.
//  Copyright (c) 2015 Denis Aganin. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var yourHealthLabel: UILabel!
    @IBOutlet weak var enemyHealthLabel: UILabel!
    @IBOutlet weak var consoleLabel: UILabel!
    @IBOutlet weak var yourPokemon: UIImageView!
    @IBOutlet weak var enemyPokemon: UIImageView!
    @IBOutlet weak var attacksView: UIView!
    @IBOutlet weak var changePokView: UIView!
    @IBOutlet weak var backPackView: UIView!
    @IBOutlet weak var enemyPokNameLabel: UILabel!
    @IBOutlet weak var yourPokNameLabel: UILabel!
    @IBOutlet weak var backButtonOutlet: UIButton!
    @IBOutlet weak var attackButtonOutlet: UIButton!
    @IBOutlet weak var charReserveHP: UILabel!
    @IBOutlet weak var pikaReserveHP: UILabel!
    @IBOutlet weak var squirtleReserveHP: UILabel!

    var player: AVAudioPlayer = AVAudioPlayer()
    
    var pokemons: [Pokemon] = []
    var enemyPokemons: [Pokemon] = []
    var chosenPokemon = Pokemon()
    var chosenEnemyPokemon = Pokemon()
    
    var pikachuAttacks: [Attack] = []
    var charmanderAttacks: [Attack] = []
    var squirtleAttacks: [Attack] = []
    var bulbasaurAttacks: [Attack] = []
    
    
    //Timer
    var count = 0
    var timer = NSTimer()
    
    @IBAction func backButton(sender: AnyObject) {
        attacksView.hidden = true
        backButtonOutlet.hidden = true
    }
    
    @IBAction func backpackOpen(sender: AnyObject) {

        if backPackView.hidden == true {
            hideViews()
            backPackView.hidden = false
        } else if backPackView.hidden == false {
            hideViews()
        }
        
    }
    
    
    @IBAction func changePok(sender: AnyObject) {
        neatChangePokScreen()
        if changePokView.hidden == true {
            hideViews()
            changePokView.hidden = false
        } else if changePokView.hidden == false {
            hideViews()
        }
    }
    
    @IBAction func attackButtonPressed(sender: AnyObject) {
        hideViews()
        attacksView.hidden = false
        backButtonOutlet.hidden = false
    }
    
    
    
    
    // Attacks of Your Pokemon
    @IBOutlet weak var tackleOutlet: UIButton!
    @IBOutlet weak var irontailOutlet: UIButton!
    @IBOutlet weak var thunderboltOutlet: UIButton!
    @IBOutlet weak var thunderOutlet: UIButton!
    
    @IBAction func tackleButton(sender: AnyObject) {
        if chosenPokemon.name == pokemons[0].name {
            tackle()
        } else if chosenPokemon.name == pokemons[2].name {
            scratch()
        } else if chosenPokemon.name == pokemons[1].name {
            tackle()
        }
    }
    
    @IBAction func irontailButton(sender: AnyObject) {
        if chosenPokemon.name == pokemons[0].name {
            ironTail()
        } else if chosenPokemon.name == pokemons[2].name {
            bite()
        } else if chosenPokemon.name == pokemons[1].name {
            ironTail()
        }
    }
    
    @IBAction func thunderboltButton(sender: AnyObject) {
        if chosenPokemon.name == pokemons[0].name {
            thunderbolt()
        } else if chosenPokemon.name == pokemons[2].name {
            flamethrower()
        } else if chosenPokemon.name == pokemons[1].name {
            waterGun()
        }
    }
    
    @IBAction func thunderButton(sender: AnyObject) {
        if chosenPokemon.name == pokemons[0].name {
            thunder()
        } else if chosenPokemon.name == pokemons[2].name {
            overheat()
        } else if chosenPokemon.name == pokemons[1].name {
            waterPulse()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defineAttacks()
        definePokemons()
        enemyChooseSquirtle()
        chooseRandomPokemon()
        pikachuButtonOutlet.enabled = false
        
        let filePath = NSBundle.mainBundle().pathForResource("Pokemon", ofType: "mp3")
        let fileData = NSData(contentsOfFile: filePath!)
        var error: NSError? = nil
        player = AVAudioPlayer(data: fileData, error: &error)
        player.volume = 0.5
        player.play()


        
    }
    
    
    
    
    // Enemy pokemons logic
    
    func enemyChooseSquirtle() {
        chosenEnemyPokemon = enemyPokemons[1]
        enemyPokNameLabel.text = chosenEnemyPokemon.name
        enemyHealthLabel.text = String(chosenEnemyPokemon.health)
        enemyPokemon.image = chosenEnemyPokemon.image
        consoleLabel.text = "Go Squirtle!"
        
    }
    func enemyChooseBulbasaur() {
        chosenEnemyPokemon = enemyPokemons[3]
        enemyPokNameLabel.text = chosenEnemyPokemon.name
        enemyHealthLabel.text = String(chosenEnemyPokemon.health)
        enemyPokemon.image = chosenEnemyPokemon.image
        consoleLabel.text = "Go Bulbasaur!"
    }
    func enemyChooseCharmander() {
        chosenEnemyPokemon = enemyPokemons[2]
        enemyPokNameLabel.text = chosenEnemyPokemon.name
        enemyHealthLabel.text = String(chosenEnemyPokemon.health)
        enemyPokemon.image = chosenEnemyPokemon.image
        consoleLabel.text = "Go Charmandericus! Burn them!"
    }

    
    
    
    // Choose pokemon
    
    @IBOutlet weak var charmanderButtonOutlet: UIButton!
    @IBOutlet weak var pikachuButtonOutlet: UIButton!
    @IBOutlet weak var squirtleBattleOutlet: UIButton!
    
    @IBAction func squirtleSummon(sender: AnyObject) {
        if chosenPokemon.name != pokemons[1].name {
            if pokemons[1].health > 0 {
                chooseSquirtle()
                squirtleBattleOutlet.enabled = false
                pikachuButtonOutlet.enabled = true
                charmanderButtonOutlet.enabled = true
                timerInit()
                enemyAttacks()
            } else {
                showAlertWithText(header: "Squirtle Fainted!", message: "Choose another pokemon or flee!")
            }
        }

    }
    
    @IBAction func charmanderSummon(sender: AnyObject) {
        if chosenPokemon.name != pokemons[2].name {
            if pokemons[2].health > 0 {
            chooseCharmander()
            charmanderButtonOutlet.enabled = false
            pikachuButtonOutlet.enabled = true
            squirtleBattleOutlet.enabled = true
            timerInit()
            enemyAttacks()
            } else {
                showAlertWithText(header: "Charmander Fainted!", message: "Choose another pokemon or flee!")
            }
        }
    }
    
    @IBAction func pikachuSummon(sender: AnyObject) {
        if chosenPokemon.name != pokemons[0].name {
            if pokemons[0].health > 0 {
            choosePikachu()
            pikachuButtonOutlet.enabled = false
            charmanderButtonOutlet.enabled = true
            squirtleBattleOutlet.enabled = true
            enemyAttacks()
            timerInit()
            } else {
                showAlertWithText(header: "Pikachu Fainted!", message: "Choose another pokemon or flee!")
            }
        }
    }
    func choosePikachu() {
        chosenPokemon = pokemons[0]
        UIView.transitionWithView(self.view, duration: 2, options: UIViewAnimationOptions.TransitionFlipFromBottom, animations: {
            self.yourPokemon.image = self.chosenPokemon.image
            self.yourHealthLabel.text = String(self.chosenPokemon.health)
            self.yourPokNameLabel.text = self.chosenPokemon.name
            self.changePokView.hidden = true
            self.consoleLabel.text = "Go Pikachu!"
            }, completion: {
                (finished:Bool) -> () in
        })
        tackleOutlet.setTitle(pikachuAttacks[0].name, forState: UIControlState.Normal)
        irontailOutlet.setTitle(pikachuAttacks[1].name, forState: UIControlState.Normal)
        thunderboltOutlet.setTitle(pikachuAttacks[2].name, forState: UIControlState.Normal)
        thunderOutlet.setTitle(pikachuAttacks[3].name, forState: UIControlState.Normal)
    }
    func chooseCharmander() {
        chosenPokemon = pokemons[2]
        UIView.transitionWithView(self.view, duration: 2, options: UIViewAnimationOptions.TransitionFlipFromBottom, animations: {
            self.yourPokemon.image = self.chosenPokemon.image
            self.yourHealthLabel.text = String(self.chosenPokemon.health)
            self.yourPokNameLabel.text = self.chosenPokemon.name
            self.changePokView.hidden = true
            self.consoleLabel.text = "Go Charmander!"
            }, completion: {
                (finished:Bool) -> () in
        })
        tackleOutlet.setTitle(charmanderAttacks[0].name, forState: UIControlState.Normal)
        irontailOutlet.setTitle(charmanderAttacks[1].name, forState: UIControlState.Normal)
        thunderboltOutlet.setTitle(charmanderAttacks[2].name, forState: UIControlState.Normal)
        thunderOutlet.setTitle(charmanderAttacks[3].name, forState: UIControlState.Normal)
        
    }
    
    func chooseSquirtle() {
        chosenPokemon = pokemons[1]
        UIView.transitionWithView(self.view, duration: 2, options: UIViewAnimationOptions.TransitionFlipFromBottom, animations: {
            self.yourPokemon.image = UIImage(named: "squir1.png")
            self.yourHealthLabel.text = String(self.chosenPokemon.health)
            self.yourPokNameLabel.text = self.chosenPokemon.name
            self.changePokView.hidden = true
            self.consoleLabel.text = "Go Squirtle!"
            }, completion: {
                (finished:Bool) -> () in
        })
        tackleOutlet.setTitle(squirtleAttacks[0].name, forState: UIControlState.Normal)
        irontailOutlet.setTitle(squirtleAttacks[1].name, forState: UIControlState.Normal)
        thunderboltOutlet.setTitle(squirtleAttacks[2].name, forState: UIControlState.Normal)
        thunderOutlet.setTitle(squirtleAttacks[3].name, forState: UIControlState.Normal)
    }

    
    
    //Combat
    
    //Potions
    
    var milkUseCount = 2
    var potionUseCount = 2
    
    @IBAction func iceColdMilk(sender: AnyObject) {
        if milkUseCount <= 0 {
            coldMilkOutlet.hidden = true
        }
        
        if chosenPokemon.health + 15 >= chosenPokemon.maxHealth {
            milkUseCount -= 1
            consoleLabel.text = "\(chosenPokemon.name) restores \(chosenPokemon.maxHealth - chosenPokemon.health) HP!"
            chosenPokemon.health = chosenPokemon.maxHealth
        } else {
        milkUseCount -= 1
        chosenPokemon.health += 15
        consoleLabel.text = "\(chosenPokemon.name) restores \(15) HP!"
        }
        hideViews()
        timerInit()
        enemyAttacks()
    }
    @IBOutlet weak var coldMilkOutlet: UIButton!
    @IBOutlet weak var potionOutlet: UIButton!
    
    @IBAction func potionDrink(sender: AnyObject) {
        if potionUseCount <= 0 {
            potionOutlet.hidden = true
        }
        if chosenPokemon.health + 25 >= chosenPokemon.maxHealth {
            potionUseCount -= 1
            consoleLabel.text = "\(chosenPokemon.name) restores \(chosenPokemon.maxHealth - chosenPokemon.health) HP!"
            chosenPokemon.health = chosenPokemon.maxHealth
        } else {
            potionUseCount -= 1
            chosenPokemon.health += 25
            consoleLabel.text = "\(chosenPokemon.name) restores \(25) HP!"
        }
        hideViews()
        timerInit()
        enemyAttacks()
    }
    
    
    //Enemy attacks
    func enemyAttacks() {
            
        if chosenEnemyPokemon.health > 0 {
            
                if count >= 2 {
                    
            var randomAttack = Int(arc4random_uniform(UInt32(4)))
            
            stopTimer()
            
            if chosenEnemyPokemon.name == enemyPokemons[1].name {
            
                switch randomAttack {
                case 0:
                    enemyTackle()
                case 1:
                    enemyIronTail()
                case 2:
                    enemyWaterGun()
                case 3:
                    enemyWaterPulse()
                default:
                    enemyTackle()
                }
            } else if chosenEnemyPokemon.name == enemyPokemons[3].name {
                
                switch randomAttack {
                case 0:
                    enemyTackle()
                case 1:
                    enemyBite()
                case 2:
                    enemyPlantSeeds()
                case 3:
                    enemyRazorLeaves()
                default:
                    enemyTackle()
                }
            } else if chosenEnemyPokemon.name == enemyPokemons[2].name {
                    
                    switch randomAttack {
                    case 0:
                        enemyScratch()
                    case 1:
                        enemyBite()
                    case 2:
                        enemyFlamethrower()
                    case 3:
                        enemyOverheat()
                    default:
                        enemyScratch()
                    }
                }
        }
        
    
    } else {
            if count >= 2 {
            consoleLabel.text = "\(chosenEnemyPokemon.name) fainted."
                if enemyPokemons[1].health <= 0 && enemyPokemons[3].health > 0 {
            enemyChooseBulbasaur()
            stopTimer()
                }
                else if enemyPokemons[1].health <= 0 && enemyPokemons[3].health <= 0 {
                    enemyChooseCharmander()
                    stopTimer()
                }
                }
            }
        attackReady()
        if chosenPokemon.health <= 0 {
            consoleLabel.text = "\(chosenPokemon.name) fainted."
            changePokView.hidden = false
            if pokemons[2].health < 0 {
                pokemons[2].health = 0
            }
            if pokemons[0].health < 0 {
                pokemons[0].health = 0
            }
            if pokemons [1].health < 0 {
                pokemons[1].health = 0
            }
            neatChangePokScreen()
        }
        
        if enemyPokemons[2].health < 0 {
            player.stop()
            performSegueWithIdentifier("Home", sender: nil)
        }
    }

    //Attacks
    
    func randomHitNumber() -> Int {
        let maxHit = 101
        var randomHitChance = Int(arc4random_uniform(UInt32(maxHit)))
        return randomHitChance
    }
    
    func tackle() {
        var hitCheck = randomHitNumber()
        if chosenPokemon.attacks[0].hitChance >= hitCheck {
        chosenEnemyPokemon.health -= chosenPokemon.attacks[0].damage
        consoleLabel.text = "\(self.chosenPokemon.name) uses \(self.chosenPokemon.attacks[0].name)! \(self.chosenEnemyPokemon.name) looses \(self.chosenPokemon.attacks[0].damage) HP!"
        } else {
            consoleLabel.text = "\(chosenPokemon.name) uses \(chosenPokemon.attacks[0].name)! Oops, that's a miss!"
        }
        attackRefreshandBack()
        timerInit()
        waitForEnemy()
        
    }
    
    func ironTail() {
        var hitCheck = randomHitNumber()
        if chosenPokemon.attacks[1].hitChance >= hitCheck {
            chosenEnemyPokemon.health -= chosenPokemon.attacks[1].damage
            consoleLabel.text = "\(self.chosenPokemon.name) uses \(self.chosenPokemon.attacks[1].name)! \(self.chosenEnemyPokemon.name) looses \(self.chosenPokemon.attacks[1].damage) HP!"
        } else {
            consoleLabel.text = "\(chosenPokemon.name) uses \(chosenPokemon.attacks[1].name)! Oops, that's a miss!"
        }
        attackRefreshandBack()
        timerInit()
        waitForEnemy()
    }
    
    func thunderbolt() {
        var hitCheck = randomHitNumber()
        if chosenPokemon.attacks[2].hitChance >= hitCheck {
            if chosenEnemyPokemon.type == "Water" {
            chosenEnemyPokemon.health -= chosenPokemon.attacks[2].damage * 2
            consoleLabel.text = "\(self.chosenPokemon.name) uses \(self.chosenPokemon.attacks[2].name)! \(self.chosenEnemyPokemon.name) looses \(self.chosenPokemon.attacks[2].damage * 2) HP! Super Effective!"
            } else {
            chosenEnemyPokemon.health -= chosenPokemon.attacks[2].damage
            consoleLabel.text = "\(self.chosenPokemon.name) uses \(self.chosenPokemon.attacks[2].name)! \(self.chosenEnemyPokemon.name) looses \(self.chosenPokemon.attacks[2].damage) HP!"
            }
        } else {
            consoleLabel.text = "\(chosenPokemon.name) uses \(chosenPokemon.attacks[2].name)! Oops, that's a miss!"
        }
        attackRefreshandBack()
        timerInit()
        waitForEnemy()
    }
    
    func thunder() {
        var hitCheck = randomHitNumber()
        if chosenPokemon.attacks[3].hitChance >= hitCheck {
            if chosenEnemyPokemon.type == "Water" {
                chosenEnemyPokemon.health -= chosenPokemon.attacks[3].damage * 2
                consoleLabel.text = "\(self.chosenPokemon.name) uses \(self.chosenPokemon.attacks[3].name)! \(self.chosenEnemyPokemon.name) looses \(self.chosenPokemon.attacks[3].damage * 2) HP! Super Effective!"
            } else {
                chosenEnemyPokemon.health -= chosenPokemon.attacks[3].damage
                consoleLabel.text = "\(self.chosenPokemon.name) uses \(self.chosenPokemon.attacks[3].name)! \(self.chosenEnemyPokemon.name) looses \(self.chosenPokemon.attacks[3].damage) HP!"
            }
        } else {
            consoleLabel.text = "\(chosenPokemon.name) uses \(chosenPokemon.attacks[3].name)! Oops, that's a miss!"
        }
        attackRefreshandBack()
        timerInit()
        waitForEnemy()
    }
    
    func scratch() {
        var hitCheck = randomHitNumber()
        if chosenPokemon.attacks[0].hitChance >= hitCheck {
            chosenEnemyPokemon.health -= chosenPokemon.attacks[0].damage
            consoleLabel.text = "\(self.chosenPokemon.name) uses \(self.chosenPokemon.attacks[0].name)! \(self.chosenEnemyPokemon.name) looses \(self.chosenPokemon.attacks[0].damage) HP!"
        } else {
            consoleLabel.text = "\(chosenPokemon.name) uses \(chosenPokemon.attacks[0].name)! Oops, that's a miss!"
        }
        attackRefreshandBack()
        timerInit()
        waitForEnemy()
        
    }
    
    func bite() {
        var hitCheck = randomHitNumber()
        if chosenPokemon.attacks[1].hitChance >= hitCheck {
            chosenEnemyPokemon.health -= chosenPokemon.attacks[1].damage
            consoleLabel.text = "\(self.chosenPokemon.name) uses \(self.chosenPokemon.attacks[1].name)! \(self.chosenEnemyPokemon.name) looses \(self.chosenPokemon.attacks[1].damage) HP!"
        } else {
            consoleLabel.text = "\(chosenPokemon.name) uses \(chosenPokemon.attacks[1].name)! Oops, that's a miss!"
        }
        attackRefreshandBack()
        timerInit()
        waitForEnemy()
    }

    func flamethrower() {
        var hitCheck = randomHitNumber()
        if chosenPokemon.attacks[2].hitChance >= hitCheck {
            if chosenEnemyPokemon.type == "Water" || chosenEnemyPokemon.type == "Fire" {
                chosenEnemyPokemon.health -= chosenPokemon.attacks[2].damage / 2
                consoleLabel.text = "\(self.chosenPokemon.name) uses \(self.chosenPokemon.attacks[2].name)! \(self.chosenEnemyPokemon.name) looses \(self.chosenPokemon.attacks[2].damage / 2) HP! Not very effective..."
            } else if chosenEnemyPokemon.type == "Grass" {
                chosenEnemyPokemon.health -= chosenPokemon.attacks[2].damage * 2
                consoleLabel.text = "\(self.chosenPokemon.name) uses \(self.chosenPokemon.attacks[2].name)! \(self.chosenEnemyPokemon.name) looses \(self.chosenPokemon.attacks[2].damage * 2) HP! Super Effective!"
            } else {
                chosenEnemyPokemon.health -= chosenPokemon.attacks[2].damage
                consoleLabel.text = "\(self.chosenPokemon.name) uses \(self.chosenPokemon.attacks[2].name)! \(self.chosenEnemyPokemon.name) looses \(self.chosenPokemon.attacks[2].damage) HP!"
            }
        } else {
            consoleLabel.text = "\(chosenPokemon.name) uses \(chosenPokemon.attacks[2].name)! Oops, that's a miss!"
        }
        attackRefreshandBack()
        timerInit()
        waitForEnemy()
    }

    func overheat() {
        var hitCheck = randomHitNumber()
        if chosenPokemon.attacks[3].hitChance >= hitCheck {
            if chosenEnemyPokemon.type == "Water" || chosenEnemyPokemon.type == "Fire" {
                chosenEnemyPokemon.health -= chosenPokemon.attacks[3].damage / 2
                consoleLabel.text = "\(self.chosenPokemon.name) uses \(self.chosenPokemon.attacks[3].name)! \(self.chosenEnemyPokemon.name) looses \(self.chosenPokemon.attacks[3].damage / 2) HP! Not very effective..."
            } else if chosenEnemyPokemon.type == "Grass" {
                chosenEnemyPokemon.health -= chosenPokemon.attacks[3].damage * 2
                consoleLabel.text = "\(self.chosenPokemon.name) uses \(self.chosenPokemon.attacks[3].name)! \(self.chosenEnemyPokemon.name) looses \(self.chosenPokemon.attacks[3].damage * 2) HP! Super Effective!"
            } else {
                chosenEnemyPokemon.health -= chosenPokemon.attacks[3].damage
                consoleLabel.text = "\(self.chosenPokemon.name) uses \(self.chosenPokemon.attacks[3].name)! \(self.chosenEnemyPokemon.name) looses \(self.chosenPokemon.attacks[3].damage) HP!"
            }
        } else {
            consoleLabel.text = "\(chosenPokemon.name) uses \(chosenPokemon.attacks[3].name)! Oops, that's a miss!"
        }
        attackRefreshandBack()
        timerInit()
        waitForEnemy()
    }
    
    
    func waterGun() {
        var hitCheck = randomHitNumber()
        if chosenPokemon.attacks[2].hitChance >= hitCheck {
            if chosenEnemyPokemon.type == "Grass" || chosenEnemyPokemon.type == "Water" {
                chosenEnemyPokemon.health -= chosenPokemon.attacks[2].damage / 2
                consoleLabel.text = "\(self.chosenPokemon.name) uses \(self.chosenPokemon.attacks[2].name)! \(self.chosenEnemyPokemon.name) looses \(self.chosenPokemon.attacks[2].damage / 2) HP! Not very effective..."
            } else if chosenEnemyPokemon.type == "Fire" {
                chosenEnemyPokemon.health -= chosenPokemon.attacks[2].damage * 2
                consoleLabel.text = "\(self.chosenPokemon.name) uses \(self.chosenPokemon.attacks[2].name)! \(self.chosenEnemyPokemon.name) looses \(self.chosenPokemon.attacks[2].damage * 2) HP! Super Effective!"
            } else {
                chosenEnemyPokemon.health -= chosenPokemon.attacks[2].damage
                consoleLabel.text = "\(self.chosenPokemon.name) uses \(self.chosenPokemon.attacks[2].name)! \(self.chosenEnemyPokemon.name) looses \(self.chosenPokemon.attacks[2].damage) HP!"
            }
        } else {
            consoleLabel.text = "\(chosenPokemon.name) uses \(chosenPokemon.attacks[2].name)! Oops, that's a miss!"
        }
        attackRefreshandBack()
        timerInit()
        waitForEnemy()

    }
    
    func waterPulse() {
        var hitCheck = randomHitNumber()
        if chosenPokemon.attacks[3].hitChance >= hitCheck {
            if chosenEnemyPokemon.type == "Water" || chosenEnemyPokemon.type == "Grass" {
                chosenEnemyPokemon.health -= chosenPokemon.attacks[3].damage / 2
                consoleLabel.text = "\(self.chosenPokemon.name) uses \(self.chosenPokemon.attacks[3].name)! \(self.chosenEnemyPokemon.name) looses \(self.chosenPokemon.attacks[3].damage / 2) HP! Not very effective..."
            } else if chosenEnemyPokemon.type == "Fire" {
                chosenEnemyPokemon.health -= chosenPokemon.attacks[3].damage * 2
                consoleLabel.text = "\(self.chosenPokemon.name) uses \(self.chosenPokemon.attacks[3].name)! \(self.chosenEnemyPokemon.name) looses \(self.chosenPokemon.attacks[3].damage * 2) HP! Super Effective!"
            } else {
                chosenEnemyPokemon.health -= chosenPokemon.attacks[3].damage
                consoleLabel.text = "\(self.chosenPokemon.name) uses \(self.chosenPokemon.attacks[3].name)! \(self.chosenEnemyPokemon.name) looses \(self.chosenPokemon.attacks[3].damage) HP!"
            }
        } else {
            consoleLabel.text = "\(chosenPokemon.name) uses \(chosenPokemon.attacks[3].name)! Oops, that's a miss!"
        }
        attackRefreshandBack()
        timerInit()
        waitForEnemy()

    }
    
    
    
    //Enemy attacks
    
    func enemyTackle() {
        var hitCheck = randomHitNumber()
        if chosenEnemyPokemon.attacks[0].hitChance >= hitCheck {
            chosenPokemon.health -= chosenEnemyPokemon.attacks[0].damage
            consoleLabel.text = "\(self.chosenEnemyPokemon.name) uses \(self.chosenEnemyPokemon.attacks[0].name)! \(self.chosenPokemon.name) looses \(self.chosenEnemyPokemon.attacks[0].damage) HP!"
        } else {
            consoleLabel.text = "\(chosenEnemyPokemon.name) uses \(chosenEnemyPokemon.attacks[0].name)! Oops, that's a miss!"
        }
        yourHealthLabel.text = String(chosenPokemon.health)
    }
    
    func enemyScratch() {
        var hitCheck = randomHitNumber()
        if chosenEnemyPokemon.attacks[0].hitChance >= hitCheck {
            chosenPokemon.health -= chosenEnemyPokemon.attacks[0].damage
            consoleLabel.text = "\(self.chosenEnemyPokemon.name) uses \(self.chosenEnemyPokemon.attacks[0].name)! \(self.chosenPokemon.name) looses \(self.chosenEnemyPokemon.attacks[0].damage) HP!"
        } else {
            consoleLabel.text = "\(chosenEnemyPokemon.name) uses \(chosenEnemyPokemon.attacks[0].name)! Oops, that's a miss!"
        }
        yourHealthLabel.text = String(chosenPokemon.health)
    }


    func enemyIronTail() {
        var hitCheck = randomHitNumber()
        if chosenEnemyPokemon.attacks[1].hitChance >= hitCheck {
            chosenPokemon.health -= chosenEnemyPokemon.attacks[1].damage
            consoleLabel.text = "\(self.chosenEnemyPokemon.name) uses \(self.chosenEnemyPokemon.attacks[1].name)! \(self.chosenPokemon.name) looses \(self.chosenEnemyPokemon.attacks[1].damage) HP!"
        } else {
            consoleLabel.text = "\(chosenEnemyPokemon.name) uses \(chosenEnemyPokemon.attacks[1].name)! Oops, that's a miss!"
        }
        yourHealthLabel.text = String(chosenPokemon.health)
    }
    
    func enemyBite() {
        var hitCheck = randomHitNumber()
        if chosenEnemyPokemon.attacks[1].hitChance >= hitCheck {
            chosenPokemon.health -= chosenEnemyPokemon.attacks[1].damage
            consoleLabel.text = "\(self.chosenEnemyPokemon.name) uses \(self.chosenEnemyPokemon.attacks[1].name)! \(self.chosenPokemon.name) looses \(self.chosenEnemyPokemon.attacks[1].damage) HP!"
        } else {
            consoleLabel.text = "\(chosenEnemyPokemon.name) uses \(chosenEnemyPokemon.attacks[1].name)! Oops, that's a miss!"
        }
        yourHealthLabel.text = String(chosenPokemon.health)
    }
    
    func enemyWaterGun() {
        var hitCheck = randomHitNumber()
        if chosenEnemyPokemon.attacks[2].hitChance >= hitCheck {
            if chosenPokemon.type == "Grass" || chosenPokemon.type == "Water" {
                chosenPokemon.health -= chosenEnemyPokemon.attacks[2].damage / 2
                consoleLabel.text = "\(self.chosenEnemyPokemon.name) uses \(self.chosenEnemyPokemon.attacks[2].name)! \(self.chosenPokemon.name) looses \(self.chosenEnemyPokemon.attacks[2].damage / 2) HP! Not very effective..."
            } else if chosenPokemon.type == "Fire" {
                chosenPokemon.health -= chosenEnemyPokemon.attacks[2].damage * 2
                consoleLabel.text = "\(self.chosenEnemyPokemon.name) uses \(self.chosenEnemyPokemon.attacks[2].name)! \(self.chosenPokemon.name) looses \(self.chosenEnemyPokemon.attacks[2].damage * 2) HP! Super Effective!"
            } else {
                chosenPokemon.health -= chosenEnemyPokemon.attacks[2].damage
                consoleLabel.text = "\(self.chosenEnemyPokemon.name) uses \(self.chosenEnemyPokemon.attacks[2].name)! \(self.chosenPokemon.name) looses \(self.chosenEnemyPokemon.attacks[2].damage) HP!"
            }
        } else {
            consoleLabel.text = "\(chosenEnemyPokemon.name) uses \(chosenEnemyPokemon.attacks[2].name)! Oops, that's a miss!"
        }
        yourHealthLabel.text = String(chosenPokemon.health)
    }
    
    func enemyWaterPulse() {
        var hitCheck = randomHitNumber()
        if chosenEnemyPokemon.attacks[3].hitChance >= hitCheck {
            if chosenPokemon.type == "Water" || chosenPokemon.type == "Grass" {
                chosenPokemon.health -= chosenEnemyPokemon.attacks[3].damage / 2
                consoleLabel.text = "\(self.chosenEnemyPokemon.name) uses \(self.chosenEnemyPokemon.attacks[3].name)! \(self.chosenPokemon.name) looses \(self.chosenEnemyPokemon.attacks[3].damage / 2) HP! Not very effective..."
            } else if chosenPokemon.type == "Fire" {
                chosenPokemon.health -= chosenEnemyPokemon.attacks[3].damage * 2
                consoleLabel.text = "\(self.chosenEnemyPokemon.name) uses \(self.chosenEnemyPokemon.attacks[3].name)! \(self.chosenPokemon.name) looses \(self.chosenEnemyPokemon.attacks[3].damage * 2) HP! Super Effective!"
            } else {
                chosenPokemon.health -= chosenEnemyPokemon.attacks[3].damage
                consoleLabel.text = "\(self.chosenEnemyPokemon.name) uses \(self.chosenEnemyPokemon.attacks[3].name)! \(self.chosenPokemon.name) looses \(self.chosenEnemyPokemon.attacks[3].damage) HP!"
            }
        } else {
            consoleLabel.text = "\(chosenEnemyPokemon.name) uses \(chosenEnemyPokemon.attacks[3].name)! Oops, that's a miss!"
        }
        yourHealthLabel.text = String(chosenPokemon.health)
    }
    
    func enemyPlantSeeds() {
        var hitCheck = randomHitNumber()
        if chosenEnemyPokemon.attacks[2].hitChance >= hitCheck {
            if chosenPokemon.type == "Grass" || chosenPokemon.type == "Fire" {
                chosenPokemon.health -= chosenEnemyPokemon.attacks[2].damage / 2
                chosenEnemyPokemon.health += chosenEnemyPokemon.attacks[2].damage / 2
                consoleLabel.text = "\(self.chosenEnemyPokemon.name) uses \(self.chosenEnemyPokemon.attacks[2].name)! \(self.chosenPokemon.name) looses \(self.chosenEnemyPokemon.attacks[2].damage / 2) HP! Not very effective..."
            } else if chosenPokemon.type == "Water" {
                chosenPokemon.health -= chosenEnemyPokemon.attacks[2].damage * 2
                chosenEnemyPokemon.health += chosenEnemyPokemon.attacks[2].damage * 2
                consoleLabel.text = "\(self.chosenEnemyPokemon.name) uses \(self.chosenEnemyPokemon.attacks[2].name)! \(self.chosenPokemon.name) looses \(self.chosenEnemyPokemon.attacks[2].damage * 2) HP! Super Effective!"
            } else {
                chosenPokemon.health -= chosenEnemyPokemon.attacks[2].damage
                chosenEnemyPokemon.health += chosenEnemyPokemon.attacks[2].damage
                consoleLabel.text = "\(self.chosenEnemyPokemon.name) uses \(self.chosenEnemyPokemon.attacks[2].name)! \(self.chosenPokemon.name) looses \(self.chosenEnemyPokemon.attacks[2].damage) HP!"
            }
        } else {
            consoleLabel.text = "\(chosenEnemyPokemon.name) uses \(chosenEnemyPokemon.attacks[2].name)! Oops, that's a miss!"
        }
        yourHealthLabel.text = String(chosenPokemon.health)
    }
    
    func enemyRazorLeaves() {
        var hitCheck = randomHitNumber()
        if chosenEnemyPokemon.attacks[3].hitChance >= hitCheck {
            if chosenPokemon.type == "Fire" || chosenPokemon.type == "Grass" {
                chosenPokemon.health -= chosenEnemyPokemon.attacks[3].damage / 2
                consoleLabel.text = "\(self.chosenEnemyPokemon.name) uses \(self.chosenEnemyPokemon.attacks[3].name)! \(self.chosenPokemon.name) looses \(self.chosenEnemyPokemon.attacks[3].damage / 2) HP! Not very effective..."
            } else if chosenPokemon.type == "Water" {
                chosenPokemon.health -= chosenEnemyPokemon.attacks[3].damage * 2
                consoleLabel.text = "\(self.chosenEnemyPokemon.name) uses \(self.chosenEnemyPokemon.attacks[3].name)! \(self.chosenPokemon.name) looses \(self.chosenEnemyPokemon.attacks[3].damage * 2) HP! Super Effective!"
            } else {
                chosenPokemon.health -= chosenEnemyPokemon.attacks[3].damage
                consoleLabel.text = "\(self.chosenEnemyPokemon.name) uses \(self.chosenEnemyPokemon.attacks[3].name)! \(self.chosenPokemon.name) looses \(self.chosenEnemyPokemon.attacks[3].damage) HP!"
            }
        } else {
            consoleLabel.text = "\(chosenEnemyPokemon.name) uses \(chosenEnemyPokemon.attacks[3].name)! Oops, that's a miss!"
        }
        yourHealthLabel.text = String(chosenPokemon.health)
    }
    
    func enemyFlamethrower() {
        var hitCheck = randomHitNumber()
        if chosenEnemyPokemon.attacks[2].hitChance >= hitCheck {
            if chosenPokemon.type == "Fire" || chosenPokemon.type == "Water" {
                chosenPokemon.health -= chosenEnemyPokemon.attacks[2].damage / 2
                consoleLabel.text = "\(self.chosenEnemyPokemon.name) uses \(self.chosenEnemyPokemon.attacks[2].name)! \(self.chosenPokemon.name) looses \(self.chosenEnemyPokemon.attacks[2].damage / 2) HP! Not very effective..."
            } else if chosenPokemon.type == "Grass" {
                chosenPokemon.health -= chosenEnemyPokemon.attacks[2].damage * 2
                consoleLabel.text = "\(self.chosenEnemyPokemon.name) uses \(self.chosenEnemyPokemon.attacks[2].name)! \(self.chosenPokemon.name) looses \(self.chosenEnemyPokemon.attacks[2].damage * 2) HP! Super Effective!"
            } else {
                chosenPokemon.health -= chosenEnemyPokemon.attacks[2].damage
                consoleLabel.text = "\(self.chosenEnemyPokemon.name) uses \(self.chosenEnemyPokemon.attacks[2].name)! \(self.chosenPokemon.name) looses \(self.chosenEnemyPokemon.attacks[2].damage) HP!"
            }
        } else {
            consoleLabel.text = "\(chosenEnemyPokemon.name) uses \(chosenEnemyPokemon.attacks[2].name)! Oops, that's a miss!"
        }
        yourHealthLabel.text = String(chosenPokemon.health)
    }
    
    func enemyOverheat() {
        var hitCheck = randomHitNumber()
        if chosenEnemyPokemon.attacks[3].hitChance >= hitCheck {
            if chosenPokemon.type == "Fire" || chosenPokemon.type == "Water" {
                chosenPokemon.health -= chosenEnemyPokemon.attacks[3].damage / 2
                consoleLabel.text = "\(self.chosenEnemyPokemon.name) uses \(self.chosenEnemyPokemon.attacks[3].name)! \(self.chosenPokemon.name) looses \(self.chosenEnemyPokemon.attacks[3].damage / 2) HP! Not very effective..."
            } else if chosenPokemon.type == "Grass" {
                chosenPokemon.health -= chosenEnemyPokemon.attacks[3].damage * 2
                consoleLabel.text = "\(self.chosenEnemyPokemon.name) uses \(self.chosenEnemyPokemon.attacks[3].name)! \(self.chosenPokemon.name) looses \(self.chosenEnemyPokemon.attacks[3].damage * 2) HP! Super Effective!"
            } else {
                chosenPokemon.health -= chosenEnemyPokemon.attacks[3].damage
                consoleLabel.text = "\(self.chosenEnemyPokemon.name) uses \(self.chosenEnemyPokemon.attacks[3].name)! \(self.chosenPokemon.name) looses \(self.chosenEnemyPokemon.attacks[3].damage) HP!"
            }
        } else {
            consoleLabel.text = "\(chosenEnemyPokemon.name) uses \(chosenEnemyPokemon.attacks[3].name)! Oops, that's a miss!"
        }
        yourHealthLabel.text = String(chosenPokemon.health)
    }



    // Defining attacks
    func defineAttacks() {
    
    let tackle = NormalAttack()
        tackle.name = "Tackle"
        tackle.damage = 15
        tackle.hitChance = 70
        
    let ironTail = NormalAttack()
        ironTail.name = "Iron Tail"
        ironTail.damage = 25
        ironTail.hitChance = 80
        
    let thunderbolt = ElectricAttack()
        thunderbolt.name = "Thunderbolt"
        thunderbolt.damage = 25
        thunderbolt.hitChance = 95
        
    let thunder = ElectricAttack()
        thunder.name = "Thunder"
        thunder.damage = 70
        thunder.hitChance = 30
        pikachuAttacks += [tackle, ironTail, thunderbolt, thunder]
        
    let scratch = NormalAttack()
        scratch.name = "Scratch"
        scratch.damage = 20
        scratch.hitChance = 75
        
    let bite = NormalAttack()
        bite.name = "Bite"
        bite.damage = 25
        bite.hitChance = 70
        
    let flamethrower = FireAttack()
        flamethrower.name = "Flamethrower"
        flamethrower.damage = 35
        flamethrower.hitChance = 85
        
    let overheat = FireAttack()
        overheat.name = "Overheat"
        overheat.damage = 80
        overheat.hitChance = 40
        charmanderAttacks += [scratch, bite, flamethrower, overheat]
        
    let waterGun = WaterAttack()
        waterGun.name = "Water Gun"
        waterGun.damage = 30
        waterGun.hitChance = 90
        
    let waterPulse = WaterAttack()
        waterPulse.name = "Water Pulse"
        waterPulse.damage = 60
        waterPulse.hitChance = 55
        squirtleAttacks += [tackle, ironTail, waterGun, waterPulse]
        
    let plantSeeds = GrassAttack()
        plantSeeds.name = "Plant Seeds"
        plantSeeds.damage = 15
        plantSeeds.hitChance = 85
        
    let razorLeaves = GrassAttack()
        razorLeaves.name = "Razor Leaves"
        razorLeaves.damage = 40
        razorLeaves.hitChance = 75
        bulbasaurAttacks += [tackle, bite, plantSeeds, razorLeaves]

    }
    
    func definePokemons() {
        
        let pikachu = ElectricPokemon()
            pikachu.name = "Pikachu"
            pikachu.maxHealth = 200
            pikachu.health = 200
            pikachu.image = UIImage(named: "pikachu.png")
            pikachu.attacks = pikachuAttacks
        enemyPokemons.append(pikachu)
        pokemons.append(pikachu)
        
        let squirtle = WaterPokemon()
            squirtle.name = "Squirtle"
            squirtle.maxHealth = 220
            squirtle.health = 220
            squirtle.image = UIImage(named: "squirtle.png")
            squirtle.attacks = squirtleAttacks
        pokemons.append(squirtle)
        
        let enemySquirtle = WaterPokemon()
            enemySquirtle.name = "Squirtle"
            enemySquirtle.maxHealth = 230
            enemySquirtle.health = 230
            enemySquirtle.image = UIImage(named: "squirtle.png")
            enemySquirtle.attacks = squirtleAttacks
        enemyPokemons.append(enemySquirtle)
        
        let charmander = FirePokemon()
            charmander.name = "Charmander"
            charmander.maxHealth = 210
            charmander.health = 210
            charmander.image = UIImage(named: "charmander.png")
            charmander.attacks = charmanderAttacks
        pokemons.append(charmander)
        
        let enemyCharmander = FirePokemon()
            enemyCharmander.name = "Charmandericus"
            enemyCharmander.maxHealth = 300
            enemyCharmander.health = 300
            enemyCharmander.image = UIImage(named: "char1.png")
            enemyCharmander.attacks = charmanderAttacks
        enemyPokemons.append(enemyCharmander)
        
        let bulbasaur = GrassPokemon()
            bulbasaur.name = "Bulbasaur"
            bulbasaur.maxHealth = 240
            bulbasaur.health = 240
            bulbasaur.image = UIImage(named: "bulbasaur.png")
            bulbasaur.attacks = bulbasaurAttacks
        enemyPokemons.append(bulbasaur)
        pokemons.append(bulbasaur)
    }
    
    
    
    
    
    //Helpers
    func attackRefreshandBack() {
        enemyHealthLabel.text = String(chosenEnemyPokemon.health)
        attacksView.hidden = true
        backButtonOutlet.hidden = true
    }
    
    func attackReady() {
        attackButtonOutlet.enabled = true
        attackButtonOutlet.setTitle("ATTACK", forState: UIControlState.Normal)
    }
    
    func waitForEnemy() {
        attackButtonOutlet.enabled = false
        attackButtonOutlet.setTitle("WAIT", forState: UIControlState.Normal)
    }
    
    func timerInit() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timerStart", userInfo: nil, repeats: true)
    }
    func timerStart() {
        count++
        enemyAttacks()
    }
    
    func stopTimer() {
        timer.invalidate()
        count = 0
    }
    
    func hideViews() {
        yourHealthLabel.text = String(chosenPokemon.health)
        changePokView.hidden = true
        backPackView.hidden = true
    }
    
    func neatChangePokScreen() {
        if pokemons[2].health < 0 {
            pokemons[2].health = 0
        }
        if pokemons[0].health < 0 {
            pokemons[0].health = 0
        }
        if pokemons[1].health < 0 {
            pokemons[1].health = 0
        }
        charReserveHP.text = "\(pokemons[2].health) HP"
        pikaReserveHP.text = "\(pokemons[0].health) HP"
        squirtleReserveHP.text = "\(pokemons[1].health) HP"
    }
    
    func chooseRandomPokemon() -> () {
        var randomPok = Int(arc4random_uniform(4))
        switch randomPok {
        case 0:
            return choosePikachu()
        case 1:
            return chooseSquirtle()
        case 2:
            return chooseCharmander()
        default:
            return chooseCharmander()
        }
    }
    
    func showAlertWithText(header : String = "Warning", message : String) {
        
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

   
}

