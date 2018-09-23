//  Created by Pawel Misiak on 8/27/18.
//  Copyright © 2018 Pawel Misiak. All rights reserved.
/*
 Concentration Game Project
 File Name: ViewController.swift
 
 Problem:
 Create a concentration card game in which all of the cards are laid face down and two cards are flipped face up over each turn. The object of the game is to turn over pairs of matching cards.In this particular example the game contains 6 pairs of 2 cards per game (12 cards total) in 3x4 format. The game tracks the amount of time you have flipped cards, and score based on matched cards.
 
 Score system:
    2 points for every match of 2 identical cards
    -1 point for every card that was already seen by the player
 
 Functions and variables:
    inverse() - takes a color and returns it's inversed color
    ViewDidLoad - necessary to set new color of the background on each start of the game
    game - creates new game from the Concentration.swift
    newGame() - resets the game to the initial state and randomy switches to new theme
    themes[] - an array of themes (in another one is added add also color to CorrespondingThemeColor array
    correspondingThemeColor[] - self explainatory - array that holds colors in the same sort as themes
    currentThemeNumber - holds the value of the currently played game theme
    getThemeNumber() - function returns index of currently played theme from themes array
    emoji - Dictionary that will get assigned Int to each String emoji
    emojiChoices[] - an array of emojis for initial startup
    emoji() - function that assigns emojis to cards
    touchCard() - Function that specifies what happens when the card is touched
    updateViewFromModel() - updates the current state of the game and displays to the user
 
    flipCountLabel - displays how many times any of the cards were flipped
    ScoreCountLabel - displays the score wich is described above in Score system
    cardButton - forms the deck of cards that is displayed on the screen
 
 Issues:
 I couldn't assign theme[0] as the first theme to start the game with and had to use emojiChoices instead
 To
 */

import UIKit

extension UIColor {
    func inverse () -> UIColor {
        var r:CGFloat = 0.0; var g:CGFloat = 0.0; var b:CGFloat = 0.0; var a:CGFloat = 0.0;
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: 1.0-r, green: 1.0 - g, blue: 1.0 - b, alpha: a)
        }
        return .black // Return a default color
    }
}

class ViewController: UIViewController { //ViewController extends UIViewController which means it inherits here

    // this function starts with the background as an inverse of the button color
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = correspondingThemeColor[currentThemeNumber].inverse()
    }

    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    //the lazy saids not to use it until it is called (create the var when you use it)
    //lazy variable cannot have didSet
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)

    @IBAction func newGame() {
        game.numberOfFlips = 0  // This var is reset here instead when init because it is refreshed to 0 on press
        game.points = 0 // The same reason as above
        emojiChoices = themes[Int(arc4random_uniform(UInt32(themes.count)))]
        currentThemeNumber = getThemeNumber()
        
        for index in game.cards.indices {
            game.cards[index].isFaceUp = false
            game.cards[index].isMatched = false
        }
        viewDidLoad()
        updateViewFromModel()
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    }

    let themes = [
        ["👻","🎃","☠️","👹","😈","🧟‍♂️","🧛🏻‍♂️","☄️","🍬"],
        ["🤾‍♀️","🏊‍♂️","🥊","🏈","🚴‍♂️","🏓","🏌🏻‍♂️","⚽️","🎳"],
        ["🍝","🥓","🍜","🥞","🍕","🍟","🍔","🌮","🌭"],
        ["🇵🇱","🇺🇸","🇵🇹","🇦🇷","🇨🇦","🇮🇹","🇩🇪","🇯🇵","🏴󠁧󠁢󠁥󠁮󠁧󠁿"],
        ["🛸","🛥","🚂","🚅","🚲","🚜","🚗","✈️","🚀"],
        ["😇","😤","😑","🤢","😱","😂","😎","😡","😀"],
        ["1","2","3","4","5","6","7","8","9"],
        ] // in another theme is included please add a color to the correspondingThemeColor array
    
    let correspondingThemeColor = [#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1),#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
    var currentThemeNumber = 0
    
    private func getThemeNumber() -> Int {
        for idx in themes.indices {
            if emojiChoices == themes[idx] {
                return idx
            }
        }
        return 0
    }
    
    var emoji = [Int: String]() // Creates a dictionary with strings and ints
    var emojiChoices = ["👻","🎃","☠️","👹","😈","🧟‍♂️","🧛🏻‍♂️","☄️","🍬"] // for some reason I cannot make this equal to themes[0]
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet weak var ScoreCountLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
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
        if sender.backgroundColor != correspondingThemeColor[currentThemeNumber].inverse() {
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
                currentButton.backgroundColor = currentCard.isMatched ? correspondingThemeColor[currentThemeNumber].inverse() : correspondingThemeColor[currentThemeNumber]
            }
        }
    }
}
