//
//  ViewController.swift
//  Concentration
//
//  Created by Дебилы Entertainment on 03.10.2023.
//  Copyright © 2023 Дебилы Entertainment. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
    private lazy var game = Concentration(numberOfPairsOfCards: (currentDiff+1)/2)
    
    private (set) var scoreCount = 0 {
        didSet {
            updateFlipCountLabel()
        }
    }
    @IBOutlet private weak var scoreCountLabel: UILabel! {
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
    
    private var currentTheme = 0
    private var currentDiff = 24
    private lazy var emojiChoices = themes[currentTheme]
    let themes = [
        "🍒🍉🍌🍊🍇🍑🥝🍏🍋🍓🌶🍕",
        "🐶🐱🦊🐴🐼🐨🦁🐷🦆🦄🦉🦇",
        "🇷🇺🇺🇦🇧🇾🇰🇿🇹🇲🇺🇿🇹🇯🇰🇬🇦🇿🇦🇲🇬🇪🇲🇩"
    ]
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet weak var stackSettings: UIStackView!
    private var visibleCardButtons: [UIButton] {
        return cardButtons.filter{ !$0.isHidden }
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            let result: Int = game.chooseCard(at: cardNumber)
            updateViewFromModel()
            scoreCount += result
        }
    }
    
    @IBAction func touchNewGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: (currentDiff+1)/2)
        scoreCount = 0
        if currentTheme == 3 {
            emojiChoices = themes[3.arc4random]
        } else {
            emojiChoices = themes[currentTheme]
        }
        game.shuffleCards()
        hint()
    }

    
    @IBAction func touchShuffle(_ sender: UIButton) {
        game.shuffleCards()
        updateViewFromModel()
    }
    
    @IBAction func touchHint(_ sender: UIButton) {
        if !game.isHintUsed() {
            game.startHint()
            hint()
        }
    }
    
    @IBAction func touchSettings(_ sender: UIButton) {
        stackSettings.isHidden = !stackSettings.isHidden
        if !stackSettings.isHidden {
            sender.setTitle("Hide", for: UIControlState.normal)
        } else {
            sender.setTitle("Settings", for: UIControlState.normal)
        }
    }
    
    @IBAction func touchTheme(_ sender: UIButton) {
        switch(sender.titleLabel!.text!){
        case "Theme":
            sender.setTitle("Animals", for: UIControlState.normal)
            currentTheme = 1
        case "Food":
            sender.setTitle("Animals", for: UIControlState.normal)
            currentTheme = 1
        case "Animals":
            sender.setTitle("Flags", for: UIControlState.normal)
            currentTheme = 2
        case "Flags":
            sender.setTitle("Random", for: UIControlState.normal)
            currentTheme = 3
        case "Random":
            sender.setTitle("Food", for: UIControlState.normal)
            currentTheme = 0
        default:
            break
        }
    }
    
    @IBAction func touchDifficulty(_ sender: UIButton) {
        switch sender.titleLabel!.text! {
        case "Difficulty":
            sender.setTitle("Easy", for: UIControlState.normal)
            currentDiff = 12
        case "Easy":
            sender.setTitle("Normal", for: UIControlState.normal)
            currentDiff = 16
        case "Normal":
            sender.setTitle("Über", for: UIControlState.normal)
            currentDiff = 24
        case "Über":
            sender.setTitle("Easy", for: UIControlState.normal)
            currentDiff = 12
        default:
            break
        }
    }
    
    private func updateViewFromModel() {
        var ind: Int = -1
        for index in visibleCardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                if card.isMatched {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                        button.setTitle("", for: UIControlState.normal)
                        button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                    }
                } else if ind == -1 {
                    ind = index
                } else {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                        button.setTitle("", for: UIControlState.normal)
                        button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                        self.cardButtons[ind].setTitle("", for: UIControlState.normal)
                        self.cardButtons[ind].backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                    }
                }
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
        for (index, button) in cardButtons.enumerated() {
            button.isHidden = index >= currentDiff
        }
        
        for index in visibleCardButtons.indices {
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
