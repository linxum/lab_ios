//
//  ViewController.swift
//  Concentration
//
//  Created by Дебилы Entertainment on 03.10.2023.
//  Copyright © 2023 Дебилы Entertainment. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairesOfCards)
    
    private (set) var scoreCount = 0 {
        didSet {
            scoreCountLabel.text = "Score: \(scoreCount)"
        }
    }
    
    var numberOfPairesOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet private weak var scoreCountLabel: UILabel!
    
    private var emojiChoices = ["🍒", "🍉", "🍌", "🍊", "🍇", "🍍", "🍑", "🥝", "🥥", "🍆", "🍏", "🍋", "🍓", "🌶", "🥕", "🍔", "🍟", "🍕"]
    
    private var emoji = Dictionary<Int, String>()
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = UIColor.white
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            }
        }
    }
    
    private func emoji(for card: Card) -> String {
        if emoji[card.id] == nil, emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.id] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card.id] ?? "?"
    }
    
    @IBAction func touchNewGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: numberOfPairesOfCards)
        scoreCount = 0
        game.shuffleCards()
        updateViewFromModel()
    }
    
    @IBAction func touchShuffle(_ sender: UIButton) {
        game.shuffleCards()
    }
}

