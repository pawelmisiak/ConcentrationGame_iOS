//
//  ViewController.swift
//  Concentration
//
//  Created by Pawel Misiak on 8/27/18.
//  Copyright © 2018 Pawel Misiak. All rights reserved.
//

import UIKit


class ViewController: UIViewController { //ViewController extends UIViewController which means it inherits here
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
            return (cardButtons.count + 1) / 2
    }
    //the lazy saids not to use it until it is called (create the var when you use it)
    //lazy variable cannot have didSet
    let themes = [
        ["👻","🎃","☠️","👹","😈","🧟‍♂️","🧛🏻‍♂️","☄️","🍬"],
        ["🤾‍♀️","🏊‍♂️","🥊","🏈","🚴‍♂️","🏓","🏌🏻‍♂️","⚽️","🎳"],
        ["🍝","🥓","🍜","🥞","🍕","🍟","🍔","🌮","🌭"],
        ["🇵🇱","🇺🇸","🇵🇹","🇦🇷","🇨🇦","🇮🇹","🇩🇪","🇯🇵","🏴󠁧󠁢󠁥󠁮󠁧󠁿"],
        ["🛸","🛥","🚂","🚅","🚲","🚜","🚗","✈️","🚀"],
        ["😇","😤","😑","🤢","😱","😂","😎","😡","😀"],
    ]
    let correspondingThemeColor = [#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1),#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)]
    var currentThemeNumber = 0
    
    @IBAction func newGame() {
        game.numberOfFlips = 0  // This var is reset here instead when init because it is refreshed to 0 on press
        game.points = 0 // The same reason as above
        emojiChoices = themes[Int(arc4random_uniform(UInt32(themes.count)))]
        currentThemeNumber = getThemeNumber()
        for index in game.cards.indices {
            game.cards[index].isFaceUp = false
            game.cards[index].isMatched = false
        }
        updateViewFromModel()
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    }
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet weak var ScoreCountLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    
//    var flipCount = 0 {
//        didSet { //whenever someone changes the flip count it will change the lable on the screen
//            flipCountLabel.text = "Flips: \(flipCount)"
//        }
//    }
    
    //var emoji = Dictionary<Int, String>() // Dictionary is a struct and it hast to be initialized
    var emoji = [Int: String]() // the same as above
    
    var emojiChoices = ["👻","🎃","☠️","👹","😈","🧟‍♂️","🧛🏻‍♂️","☄️","🍬"]
    
    private func getThemeNumber() -> Int {
        for idx in themes.indices {
            if emojiChoices == themes[idx] {
                return idx
            }
        }
        return 0
    }
    
    func emoji(for card: Card) -> String { // calling for internally card
        if emoji[card.identifier] == nil {
            if emojiChoices.count > 0 {
                let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count))) // Int() converts the unsigned int
                emoji[card.identifier] = emojiChoices[randomIndex]
                emojiChoices.remove(at: randomIndex) // after making the selection we have to remove it from the choices
            }
        }
         return emoji[card.identifier] ?? "?"
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if sender.backgroundColor != #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
            if let cardNumber = cardButtons.index(of: sender) {
                game.chooseCard(at: cardNumber)
                updateViewFromModel();
            } else {
                print("Chosen card isn't in the cardButtons")
            }
            updateViewFromModel();
        }
    }
    
    func updateViewFromModel() {
        flipCountLabel.text = "Flips: \(game.numberOfFlips)"
        ScoreCountLabel.text = "Score: \(game.points)"
        for index in cardButtons.indices {
            let currentButton = cardButtons[index]
            let currentCard = game.cards[index]
            if currentCard.isFaceUp {
                currentButton.setTitle(emoji(for: currentCard), for: UIControlState.normal)
                currentButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                currentButton.setTitle("", for: UIControlState.normal)
                currentButton.backgroundColor = currentCard.isMatched ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : correspondingThemeColor[currentThemeNumber]
            }
        }
    }
}

