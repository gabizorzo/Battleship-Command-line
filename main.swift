//
//  main.swift
//  Battleship
//
//  Created by Gabriela Zorzo and João Dall Agnol
//

import Foundation
import AVFoundation

var audio = Audio()

    func getIntFromCommandLine(message: String, rangeMin: Int, rangeMax: Int) -> Int {
        print(message)
        while(true) {
            if let input = readLine()
            {
                if let int = Int(input)
                {
                    if int >= rangeMin && int <= rangeMax {
                        return int
                    } else {
                        print("\(input) is not in range [\(rangeMin)-\(rangeMax)]. Please try againt")
                    }
                }
                else{
                    print("\(input) is not a valid integer. Please try againt")
                }
            }
        }
    }
    
    func getShotCoordinatesForPlayer(engine: Game,
                                      maxRows: Int,
                                      maxCols: Int) -> (row: Int, col: Int)? {
        while(true) {
            let row = getIntFromCommandLine(message: "Enter row",
                                            rangeMin: 1,
                                            rangeMax: maxRows)
            let col = getIntFromCommandLine(message: "Enter column",
                                            rangeMin: 1,
                                            rangeMax: maxCols)
            
            if engine.mayShot(who: .player, row: row, col: col) {
                return (row: row, col: col)
            }
        }
    }
    
    print("YOUR NAME:")
    let name = readLine()
   // let shipsSize = [4, 3, 3, 2, 2, 2, 1, 1, 1, 1]
    let shipsSize = [3, 1]
   // let shipsNumber = 10
    let shipsNumber = 2
    let game = Game(rows: 10, cols: 10, shipsSize: shipsSize, life: shipsNumber)
    let computerReady = game.shipsAutoSetup(shipsSize: shipsSize, maxTriesPerShip: 20, who: .computer)
    let playerReady = game.shipsPlayerSetup(shipsSize: shipsSize, who: .player)
    var whoseTurn = Game.Who.player
    var coordinates: (row: Int, col: Int)?

    game.printHeadline()
    game.printBoards()

    if computerReady, playerReady {
    while(true){
        print("\n\n\nIT IS YOUR TURN: \(whoseTurn)")
        
        if whoseTurn == Game.Who.player {
            coordinates = getShotCoordinatesForPlayer(engine: game, maxRows: 10, maxCols: 10)
            if coordinates == nil {
                print("Player can't shoot")
                break
            } else {
                print("Shot at row \(coordinates!.row) and column \(coordinates!.col)")
            }
            game.shot(who: whoseTurn, row: coordinates!.row, col: coordinates!.col)
            whoseTurn = Game.Who.computer
        } else {
            coordinates = game.getShotCoordinatesForComputer(maxTries: 100)
            if coordinates == nil {
                print("Opponent can't shoot")
                break
            } else {
                print("Shot at row \(coordinates!.row) and column \(coordinates!.col)")
           }
            game.shot(who: whoseTurn, row: coordinates!.row, col: coordinates!.col)
            whoseTurn = Game.Who.player
        }
        
        game.printBoards()
        if let who = game.checkWhoWins() {
            if who == .player {
                print("CONGRATULATIONS ✨✨\(name!)✨✨, YOU ARE THE WINNER!")
            } else {
            print("YOU LOST 😭")
            }
            break
        }
    }
} else {
    print("Can't arrange all ships")
}


