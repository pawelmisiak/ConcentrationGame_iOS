//  Created by Pawel Misiak on 9/5/18.
//  Copyright © 2018 Pawel Misiak. All rights reserved.
/*
 Concentration Game Project
 File Name: Card.swift
 
 Description of the file:
 This is the Card class file that models the card and all it's attributes
 
 Functions and variables:
    isFaceUp - boolean value indicating if the card is turned face up
    isMatched - boolean value indicating if current card has a match
    identifier - unique value for each card - necessary for the Concentration.swift
    identifierFactory - value to hold unique identifier for each card
    getUniqueIdentifier() - function to generate identifierFactory numbers
 
 Issues:
 */

import Foundation

struct Card {
    
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    
    private static var identifierFactory = 0;
    
    private static func getUniqueIdentifier() -> Int {  // makes it class method and not an instance method
        identifierFactory += 1                  // it will only work with static variables
        return Card.identifierFactory
    }
    init() {
        self.identifier = Card.getUniqueIdentifier() // since init is not static we need to specify the class
    }
}
