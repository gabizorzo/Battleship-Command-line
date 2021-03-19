//
//  Ship.swift
//  Battleship
//
//  Created by Gabriela Zorzo and João Dall Agnol
//

import Foundation

class Ship {
    private let size: Int
    private var lifePoints: Int
    var position: [(row: Int, col: Int, status: Status)]
    
    var isDestroyed: Bool {
        return lifePoints == 0 ? true : false
    }
    
    enum Direction {
        case up, down, left, right
    }
    
    enum Status {
        case damaged, ready, destroyed
    }
    
    init(size: Int, position: [(row: Int, col: Int, status: Status)]) {
        self.size = size
        self.position = position
        self.lifePoints = size
    }
    
    // confere se a posição do tiro coincide com alguma das posições do ship
    func hitAt(row: Int, col: Int) {
        for (index, coordinate) in position.enumerated() {
            if coordinate.row == row && coordinate.col == col {
                position[index].status = Status.damaged
                lifePoints -= 1 // remove uma "vida"
                break
            }
        }
    }
    
    // confere a localização do ship !!!!!
    func isLocatedAt(row: Int, col: Int) -> Bool {
        for coordinate in position {
            if coordinate.row == row && coordinate.col == col {
                return true
            }
        }
        return false
    }
}
