//
//  CallFire.swift
//  RedFive
//
//  Created by John Piersol on 11/16/15.
//  Copyright © 2015 Sean Crabtree. All rights reserved.
//

import Foundation

class CallFire {
    
    func getTexts() -> [CFText] {
        return []
    }
    
    func getText(id: Int64) -> CFText {
        return CFText()
    }

    func getNumbers() -> [CFNumber] {
        let numbersJSON = JSON(["name":"(310) 555-1234","calls":"100","transfers":"60","missed":"40","texts":"50"])
        let numbersData = CFNumber(withJSON: numbersJSON)
        var numbers:[CFNumber] = []
        numbers.append(numbersData)
        return numbers;
    }
}
