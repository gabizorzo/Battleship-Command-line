//
//  Game.swift
//  Battleship
//
//  Created by Gabriela Zorzo and João Dall Agnol
//

import Foundation
import AVFoundation

class Game {
    private var boardPlayer: Board
    private var boardComputer: Board
    private var shipsSize: [Int]
    private var rows, cols: Int
    var life: Int
    var audio: Audio

    enum Who {
        case player, computer
    }
    
    init(rows: Int, cols: Int, shipsSize: [Int], life: Int) {
        self.boardPlayer = Board(rows: rows, cols: cols, life: life)
        self.boardComputer = Board(rows: rows, cols: cols, life: life)
        
        self.shipsSize = shipsSize
        
        self.rows = rows
        self.cols = cols
        
        self.life = life
        
        self.audio = Audio()
        
    }
       
    
    // confere quem ganhou
    func checkWhoWins() -> Who? {
        if boardPlayer.life == 0 {
            return Who.computer
        } else if boardComputer.life == 0 {
            sleep(3)
            audio.playOhLoco()
            sleep(2)
            return Who.player
        }
        return nil
    }
    
    // atira pelo computador aleatoriamente
    func getShotCoordinatesForComputer(maxTries: Int) -> (row: Int, col: Int)? {
        var row, col: Int?
        
        // aleatoriamenyr
        for _ in 1...maxTries {
            row = GameUtils.getRandomInt(from: 1, to: rows)
            col = GameUtils.getRandomInt(from: 1, to: cols)
            
            if let r = row, let c = col {
                if mayShot(who: Who.computer, row: r, col: c) {
                    return (row: r, col: c)
                }
            }
        }
        
        // se o aleatorio falha, busca um próximo
        for r in 0...rows+1 {
            for c in 0...cols+1 {
                if mayShot(who: Who.computer, row: r, col: c) {
                    return (row: r, col: c)
                }
            }
        }
        return nil
    }
    
    // chama o mayPlaceShip do board
    func mayPlaceShip(who: Who, size: Int, anchorRow: Int, anchorCol: Int, direction: Ship.Direction) -> Bool {
        
        let anchor = (row: anchorRow, col: anchorCol)
        let boardWho = getWhoBoard(who: who)
        return boardWho.mayPlaceShip(size: size,
                                 anchor: anchor,
                                 direction: direction)
    }
    
    // chama o placeShip do board
    func placeShip(who: Who, size: Int, anchorRow: Int, anchorCol: Int, direction: Ship.Direction) {
        let anchor = (row: anchorRow, col: anchorCol)
        let boardWho = getWhoBoard(who: who)
        boardWho.placeShip(size: size, anchor: anchor, direction: direction)
    }
    
    // chama o shipAutoSetup do board
    func shipsAutoSetup(shipsSize: [Int], maxTriesPerShip: Int, who: Who) -> Bool {
        let boardWho = getWhoBoard(who: who)
        let number = boardWho.shipsAutoSetup(shipsSize: shipsSize, maxTriesPerShip: maxTriesPerShip)
        
        if shipsSize.count == number {
            return true
        }
        
        return false
    }
    
    func shipsPlayerSetup(shipsSize: [Int], who: Who) -> Bool {
        let boardWho = getWhoBoard(who: who)
        let number = boardWho.shipsPlayerSetup(shipsSize: shipsSize)
        
        if shipsSize.count == number {
            return true
        }
        
        return false
    }
    
    // busca de quem é o borad da vez
     func getWhoBoard(who: Who) -> Board {
            if who == Who.player {
                return boardPlayer
            }
            return boardComputer
    }
    
    // busca quem é o alvo da vez
    func getWhoTarget(who: Who) -> Who {
            if who == Who.player {
                return Who.computer
            }
            return Who.player
        }
    
    // chama o mayShot do board
    func mayShot(who: Who, row: Int, col: Int) -> Bool {
        let boardWho = getWhoBoard(who: getWhoTarget(who: who))
        return boardWho.mayShot(row: row, col: col)
    }
     
    // chama o shot do board
    func shot(who: Who, row: Int, col: Int) {
        let boardWho = getWhoBoard(who: getWhoTarget(who: who))
        boardWho.shot(row: row, col: col)
    }
    
    func printHeadline() {
        print("\nWELCOME TO BATTLESHIP! \nARE YOU READY? \n")
    }
    
    func printBoards() {
        print("PLAYER")
        boardPlayer.printBoard()
        print("COMPUTER")
        boardComputer.printBoard()
    }
    
}

