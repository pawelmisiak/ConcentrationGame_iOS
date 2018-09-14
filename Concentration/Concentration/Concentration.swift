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
    
    var indexOfOneAndOnlyFaceUpCard: Int? // is initialized to be nil
    
    func chooseCard(at index: Int) {
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
        for _ in 0..<numberOfPairsOfCards { // unerbar says there is no var associated with this loop
            let card = Card()
            cards += [card, card]
        }
        //cards.shuffle()
    }
}
