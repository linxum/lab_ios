//
//  Concentration.swift
//  Concentration
//
//  Created by Дебилы Entertainment on 23.10.2023.
//  Copyright © 2023 Дебилы Entertainment. All rights reserved.
//

import Foundation

struct Concentration {
    
    private (set) var cards = [Card]()
    
    private var isHint: Bool
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        
        set (newValue){
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func chooseCard(at index: Int) -> Int {
        var result = 0
        assert(cards.indices.contains(index), "Concentration.chooseCard(at:\(index)):choosen index not in the cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    result += 1
                } else { result -= 2}
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
        return result
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): too must at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        isHint = false
        shuffleCards()
    }
    
    mutating func shuffleCards() {
        var shuffledCards = [Card]()
        var unshuffledCards = cards
        
        while !unshuffledCards.isEmpty {
            let card = unshuffledCards.remove(at: unshuffledCards.count.arc4random)
            shuffledCards.append(card)
        }
        
        cards = shuffledCards
    }
    
    mutating func startHint() {
        self.isHint = true
    }
    
    func isHintUsed() -> Bool {
        return isHint
    }
}
