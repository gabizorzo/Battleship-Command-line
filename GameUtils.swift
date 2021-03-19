//
//  GameUtils.swift
//  Battleship
//
//  Created by Gabriela Zorzo on 17/03/21.
//

import Foundation

class GameUtils {
    // para imprimir o dígito 1 do número 10 no tabuleiro
    class func determineNumberOfdigits(number: Int) -> Int {
                var value = 10
                
                guard number > 0 else {return 0}
                
                for digits in 1...10 {
                    if (value > number) {
                        return digits
                    }
                    value *= 10
                }
                
                return 0
            }
    
    // sorteia um número aleatório
    class func getRandomInt(from: Int, to: Int, excluding: [Int]? = nil) -> Int? {
        let maxTries = 10
        var candidate = -1
        
        if from == to {
            return from
        }
        
        for _ in 0 ..< maxTries {
            candidate = Int.random(in: from ... to)
            
            if excluding != nil {
                if !excluding!.contains(candidate) {
                    return candidate
                }
            } else {
                return candidate
            }
        }
        
        return nil
    }
}
