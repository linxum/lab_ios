//
//  Card.swift
//  Concentration
//
//  Created by Debils Entertainment on 23.10.2023.
//  Copyright © 2023 Debils Entertainment. All rights reserved.
//

import Foundation

struct Card: Hashable {
    var hashValue: Int { return id}
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
    
    var isFaceUp = false
    var isMatched = false
    private var id : Int
    
    private static var idFactory = 0
    
    private static func getUniqueID() -> Int {
        Card.idFactory += 1
        return Card.idFactory
    }
    
    init() {
        self.id = Card.getUniqueID()
    }
}
