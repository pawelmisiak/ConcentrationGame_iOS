//
//  Concentration.swift
//  Concentration
//
//  Created by Pawel Misiak on 9/5/18.
//  Copyright © 2018 Pawel Misiak. All rights reserved.
//

import Foundation

class Concentration {
    
    var cards = Array<Card>() // this equals [Card]() // parents are initializing an empty array
    
    private var indexOfOneAndOnlyFaceUpCard: Int? // is initialized to be nil
    
    
    func chooseCard(at index: Int) { // this is not private because viewcontroller calls it so its public
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil;
            } else {
                // either 0 or 2 cards are faceUp
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 0..<numberOfPairsOfCards { // underscore says there is no var associated with this loop
            let card = Card()
            cards += [card, card]
        }
        
        // Shuffling the cards using swapAt and arc4random with upper bound
//        var decreasingIterator = cards.count-1
//        while decreasingIterator > 0 {
//            let rand = Int(arc4random_uniform(UInt32(decreasingIterator)))
//            cards.swapAt(decreasingIterator, rand)
//            decreasingIterator -= 1
//        }
        
    }
}
