//
//  Ships.swift
//  Battleship
//
//  Created by Gabriela Zorzo and João Dall Agnol
//

import Foundation

class Ships{
    var ships = [String: Ship]() // ver se é necessário ser String!!!
    func shipsAtCommand() -> Int {
        var shipsNumber = ships.count
        
        for (_, ship) in ships {
            if ship.isDestroyed {
                shipsNumber -= 1
            }
        }
        return shipsNumber
    }
}
