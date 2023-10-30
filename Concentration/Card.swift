//
//  Card.swift
//  Concentration
//
//  Created by Дебилы Entertainment on 23.10.2023.
//  Copyright © 2023 Дебилы Entertainment. All rights reserved.
//

import Foundation

struct Card {
    var isFaceUp = false
    var isMatched = false
    var id : Int
    
    private static var idFactory = 0
    
    private static func getUniqueID() -> Int {
        Card.idFactory += 1
        return Card.idFactory
    }
    
    init() {
        self.id = Card.getUniqueID()
    }
}