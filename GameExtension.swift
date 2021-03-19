//
//  GameExtension.swift
//  Battleship
//
//  Created by Gabriela Zorzo on 17/03/21.
//

import Foundation

// Coloca um espaço para imprimir o tabuleiro
extension String {
    func leftPadding(toLength: Int, withPad: String = " ") -> String {
        guard toLength > self.count else {return self}
        
        let padding = String(repeating: withPad, count: toLength - self.count)
        
        return padding + self
    }
}
