//
//  ViewController.swift
//  Concentration
//
//  Created by Pawel Misiak on 8/27/18.
//  Copyright © 2018 Pawel Misiak. All rights reserved.
//

import UIKit


class ViewController: UIViewController { //ViewController extends UIViewController which means it inherits here
    
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count / 2))
    //the lazy saids not to use it until it is called (create the var when you use it)
    //lazy variable cannot have didSet
    
    @IBOutlet weak var Reset: UIButton!
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    var flipCount = 0 {
        didSet { //whenever someone changes the flip count it will change the lable on the screen
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    //var emoji = Dictionary<Int, String>() // Dictionary is a struct and it hast to be initialized
    var emoji = [Int: String]() // the same as above
    
    var emojiChoices = ["👻","🎃","☠️","👹","😈","🧟‍♂️","🧛🏻‍♂️","☄️","🍬"]
    
    func emoji(for card: Card) -> String { // calling for internally card
        if emoji[card.identifier] == nil {
            if emojiChoices.count > 0 {
                let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count))) // Int() converts the unsigned int
                emoji[card.identifier] = emojiChoices[randomIndex]
                emojiChoices.remove(at: randomIndex) // after making the selection we have to remove it from the choices
            }
        }
         return emoji[card.identifier] ?? "?"  // < -- this is the same as the declaration above
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if sender.backgroundColor != #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
            flipCount += 1
        }
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel();
        } else {
            print("Chosen card isn't in the cardButtons")
        }
        updateViewFromModel();
    }
    
        func updateViewFromModel() {
            for index in cardButtons.indices {
                let button = cardButtons[index]
                let card = game.cards[index]
                if card.isFaceUp {
                    button.setTitle(emoji(for: card), for: UIControlState.normal)
                    button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                } else {
                    button.setTitle("", for: UIControlState.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1) // same as the one above
                    
                }
  
            }
    }
    
    //this got replaced by updateViewFromModel()
//    func flipCard(withEmoji emoji: String, on button: UIButton) {
//        if button.currentTitle == emoji {
//            button.setTitle("", for: UIControlState.normal)
//            button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
//        } else {
//            button.setTitle(emoji, for: UIControlState.normal)
//            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        }
//    }
}

