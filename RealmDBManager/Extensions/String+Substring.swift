//
//  String+Substring.swift
//  PlannerDiary
//
//  Created by sama73 on 2019. 1. 14..
//  Copyright © 2019년 sama73. All rights reserved.
//

import Foundation

extension String {
    
    // LEFT
    // Returns the specified number of chars from the left of the string
    // let str = "Hello"
    // print(str.left(3))         // Hel
    func left(_ to: Int) -> String {
        return String(self.prefix(to))
    }
    
    // RIGHT
    // Returns the specified number of chars from the right of the string
    // let str = "Hello"
    // print(str.left(3))         // llo
    func right(_ from: Int) -> String {
        return String(self.suffix(from))
    }
    
    // MID
    // Returns the specified number of chars from the startpoint of the string
    // let str = "Hello"
    // print(str.left(2,amount: 2))         // ll
    func mid(_ from: Int) -> String {
        return String(self[self.index(startIndex, offsetBy: from)...])
    }
    
    func mid(_ from: Int, amount: Int) -> String {
        let x = "\(self[self.index(startIndex, offsetBy: from)...])"
        return x.left(amount)
    }
}
