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
            updateFlipCountLabel()
        }
    }
    
    private func updateFlipCountLabel() {
        let attr: [NSAttributedStringKey: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        ]
        let attrString = NSAttributedString(string: "Score: \(scoreCount)", attributes: attr)
        scoreCountLabel.attributedText = attrString
    }
    
    @IBOutlet private weak var scoreCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    
    
    var numberOfPairesOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    @IBOutlet weak var hintButton: UIButton!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            let result: Int = game.chooseCard(at: cardNumber)
            updateViewFromModel()
            scoreCount += result
        }
    }
    
    @IBAction func touchNewGame(_ sender: UIButton) {
        emojiChoices = "🍒🍉🍌🍊🍇🍍🍑🥝🥥🍆🍏🍋🍓🌶🥕🍕"
        game = Concentration(numberOfPairsOfCards: numberOfPairesOfCards)
        scoreCount = 0
        game.shuffleCards()
        updateViewFromModel()
        hint()
    }
    
    @IBAction func touchShuffle(_ sender: UIButton) {
        game.shuffleCards()
        updateViewFromModel()
    }
    
    @IBAction func touchHint(_ sender: UIButton) {
        hint()
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            }
        }
        
        if !game.isHintUsed() {
            hintButton.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        } else {
            hintButton.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
    
    private func hint() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if !card.isMatched {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
            self.updateViewFromModel()
        }
    }
    
    private var emojiChoices = "🍒🍉🍌🍊🍇🍍🍑🥝🥥🍆🍏🍋🍓🌶🥕🍕"
    
    private var emoji = [Card: String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
