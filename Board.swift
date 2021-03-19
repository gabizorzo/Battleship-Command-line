//
//  Board.swift
//  Battleship
//
//  Created by Gabriela Zorzo and João Dall Agnol
//

import Foundation

class Board{
    private let rows, cols: Int
    private var board: [[CellType]]
    var ships: Ships
    var life: Int
    var audio: Audio
    
    enum CellType {
        case none, empty, hit, notAllowed, water, ship, shot
    }
    
    init(rows: Int, cols: Int, life: Int) {
        self.rows = rows
        self.cols = cols
        
        self.life = life
        
        self.ships = Ships()
        
        self.audio = Audio()
        
        board = Array (repeating: (Array (repeating: .none, count: cols+2)), count: rows+2) // cria a matriz
        prepareboard()
    }
    
    // preparar o Board determinando os valores das células
    func prepareboard() {
        // determina limites colunas
        for i in 0...rows+1 {
            board[i][0] = .notAllowed
            board[i][cols+1] = .notAllowed
        }
        
        // determina limites de linhas
        for i in 0...cols+1 {
            board[0][i] = .notAllowed
            board[rows+1][i] = .notAllowed
        }
        
        // determina posições vazias no meio do board
        for r in 1...rows {
            for c in 1...cols {
                board[r][c] = .empty
            }
        }
    }
    
    // posiciona o ship no board marcando as posiçoes adjacentes como notAllowed
    func placeShip(size: Int, anchor: (row: Int, col: Int), direction: Ship.Direction) {
        var modifier: (forRow: Int, forCol: Int)!
        var r: Int!
        var c: Int!
        var position = [(row: Int, col: Int, status: Ship.Status)]()
        
        switch direction {
        case .up:
            modifier = (forRow: -1, forCol:  0)
        case .down:
            modifier = (forRow: +1, forCol:  0)
        case .left:
            modifier = (forRow:  0, forCol: -1)
        case .right:
            modifier = (forRow:  0, forCol: +1)
        }
        
        // percorre todo o tamanho do ship
        for i in 0...size-1 {
            r = anchor.row + i*modifier.forRow
            c = anchor.col + i*modifier.forCol
            
            // posiciona o ship
            board[r][c] = CellType.ship
            position.append((row: r,
                             col: c,
                             status: .ready))
            
            // Delimita as bordas na lateral do ship que não podem ser posicionados outros ships
            r = anchor.row+(modifier.forCol) + i*modifier.forRow
            c = anchor.col+(modifier.forRow) + i*modifier.forCol
            board[r][c] = .notAllowed
            
            r = anchor.row-(modifier.forCol) + i*modifier.forRow
            c = anchor.col-(modifier.forRow) + i*modifier.forCol
            board[r][c] = .notAllowed
        }
        
        // Delimita as bordas no anchor do ship que não podem ser posicionados outros ships
        r = anchor.row + (-1)*modifier.forRow
        c = anchor.col + (-1)*modifier.forCol
        board[r][c] = .notAllowed
        
        r = anchor.row+(modifier.forCol) + (-1)*modifier.forRow
        c = anchor.col+(modifier.forRow) + (-1)*modifier.forCol
        board[r][c] = .notAllowed
        
        r = anchor.row-(modifier.forCol) + (-1)*modifier.forRow
        c = anchor.col-(modifier.forRow) + (-1)*modifier.forCol
        board[r][c] = .notAllowed
        
        // Delimita as bordas no oposto do anchor do ship que não podem ser posicionados outros ships
        r = anchor.row + (size)*modifier.forRow
        c = anchor.col + (size)*modifier.forCol
        board[r][c] = .notAllowed
        
        r = anchor.row+(modifier.forCol) + (size)*modifier.forRow
        c = anchor.col+(modifier.forRow) + (size)*modifier.forCol
        board[r][c] = .notAllowed
        
        r = anchor.row-(modifier.forCol) + (size)*modifier.forRow
        c = anchor.col-(modifier.forRow) + (size)*modifier.forCol
        board[r][c] = .notAllowed
        
        // passa o valor do anchor para o Ship
        ships.ships["\(anchor)"] = Ship(size: size, position: position)
    }
    
    // verificar se os espaços necessários para posicionar o ship estão empty
    func mayPlaceShip(size: Int, anchor: (row: Int, col: Int), direction: Ship.Direction) -> Bool {
        var modifier: (forRow: Int, forCol: Int)!
        var r: Int!
        var c: Int!
        
        switch direction {
        case .up:
            modifier = (forRow: -1, forCol:  0)
        case .down:
            modifier = (forRow: +1, forCol:  0)
        case .left:
            modifier = (forRow:  0, forCol: -1)
        case .right:
            modifier = (forRow:  0, forCol: +1)
        }
        
        for i in 0...size-1 {
            r = anchor.row + i*modifier.forRow
            c = anchor.col + i*modifier.forCol
            
            guard r>0, r<rows+1 else {return false}
            guard c>0, c<cols+1 else {return false}
            
            if board[r][c] != .empty {
                return false
            }
        }
        return true
    }
    
    // posiciona os ships aleatoriamente para o computador
    func shipsAutoSetup(shipsSize: [Int], maxTriesPerShip: Int) -> Int {
        var shipDirection = Ship.Direction.up
        var possible = true
        var success: Bool
        var positioned = 0
        var anchor: (row: Int, col: Int)
        
        for size in shipsSize {
            success = false
            for _ in 1...maxTriesPerShip {
                if let r = GameUtils.getRandomInt(from: 1, to: rows),
                    let c = GameUtils.getRandomInt(from: 1, to: cols) {
                
                    anchor = (row: r, col: c)
                
                    if let direction = GameUtils.getRandomInt(from: 1, to: 4) {
                        switch direction {
                        case 1: shipDirection = .up
                        case 2: shipDirection = .right
                        case 3: shipDirection = .down
                        default: shipDirection = .left
                        }
                        possible = mayPlaceShip(size: size,
                                                anchor: anchor,
                                                direction: shipDirection)
                
                        if possible {
                            placeShip(size: size,
                                      anchor: anchor,
                                      direction: shipDirection)
                            positioned += 1
                            success = true
                            break
                        }
                    }
                }
            }
            if !success {
                return positioned
            }
        }
        return positioned
    }
    
    
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
    
    func shipsPlayerSetup(shipsSize: [Int]) -> Int {
        var shipDirection = Ship.Direction.up
        var possible = true
        var success: Bool
        var positioned = 0
        var anchor: (row: Int, col: Int)
        let maxRows = 10
        let maxCols = 10
        
        print("\n🛳 LET'S PLACE YOUR SHIPS! 🛳")
        
        for size in shipsSize {
            success = false
            for _ in 1...10 {
                print("\nThe ship size is \(size)")
                printBoard()
                let r = getIntFromCommandLine(message: "Enter row",
                                                   rangeMin: 1,
                                                   rangeMax: maxRows)
                let c = getIntFromCommandLine(message: "Enter column",
                                                   rangeMin: 1,
                                                   rangeMax: maxCols)
                
                anchor = (row: r, col: c)
                
                let direction = getIntFromCommandLine(message: "Enter ship direction: 1 for up, 2 for right, 3 for down, 4 for left.", rangeMin: 1, rangeMax: 4)
                switch direction {
                case 1: shipDirection = .up
                case 2: shipDirection = .right
                case 3: shipDirection = .down
                case 4: shipDirection = .left
                        default: print("Not avaliable")
                        }
                        possible = mayPlaceShip(size: size,
                                                anchor: anchor,
                                                direction: shipDirection)
                
                        if possible {
                            placeShip(size: size,
                                      anchor: anchor,
                                      direction: shipDirection)
                            positioned += 1 
                            success = true
                            break
                        } else {
                            print("\nCould not place ship. Try again!")

                        }
            }
            if !success {
                return positioned
            }
            
        }
        return positioned
    }
    
    
    // testar se o tiro é válido
    func mayShot(row: Int, col: Int) -> Bool {
        let yes: Set<Board.CellType> = [.empty,
                                        .ship,
                                        .notAllowed]
        
        if yes.contains(board[row][col]) {
            return true
        }
        
        let no: Set<Board.CellType> = [.hit,
                                       .shot]
        
        if no.contains(board[row][col]) {
            return false
        }
        
        return false
    }
    
    // marca water na volta do ship quando ele for destruído
    func markWhenShipDestroyed(ship: Ship) {
        let allCellsArround = [(rowModifier: -1, colModifier:  0),// top
            (rowModifier: -1, colModifier: +1),// top-right
            (rowModifier:  0, colModifier: +1),// right
            (rowModifier: +1, colModifier: +1),// bottom-right
            (rowModifier: +1, colModifier:  0),// bottom
            (rowModifier: +1, colModifier: -1),// bottom-left
            (rowModifier:  0, colModifier: -1),// left
            (rowModifier: -1, colModifier: -1)// top-left
        ]
        
        var row, col: Int
        
        for (r, c, _) in ship.position {
            for modifier in allCellsArround {
                row = r + modifier.rowModifier
                col = c + modifier.colModifier
                
                let chageToRescue: Set<Board.CellType> = [.empty,
                                                          .shot,
                                                          .notAllowed]
                
                if chageToRescue.contains(board[row][col]) {
                        board[row][col] = Board.CellType.water
                }
            }
        }
    }
    
    // remover uma vida caso o ship tenha sido completamente destruído
    func afterHitAction(row: Int, col: Int) {
        for (_, ship) in ships.ships {
            if ship.isLocatedAt(row: row, col: col) {
                ship.hitAt(row: row, col: col)
                if ship.isDestroyed {
                    markWhenShipDestroyed(ship: ship)
                    life -= 1
                    audio.playPegandoFogo()
                }
            }
        }
    }
    
    // atirar
    func shot(row: Int, col: Int) {
        if board[row][col] == .empty || board[row][col] == .notAllowed {
            board[row][col] = .shot
            audio.playErrou()
        } else if board[row][col] == .ship {
            board[row][col] = .hit
            audio.playAcertou()
            afterHitAction(row: row, col: col)
        }
    }
    
    func printBoard() {
        let leadingPadding = GameUtils.determineNumberOfdigits(number: rows)
        var leadingPaddingString = ""
        var line = ""
        var digit = 0
        
        for _ in 1...leadingPadding {
            leadingPaddingString += " "
        }
        
        line = leadingPaddingString + "  "
        for c in 1...cols {
            digit = c/10
            if digit == 0 {
                line += "  " // nao apagar esse espaço
            } else {
                line += " \(digit)"
            }
        }
        
        print(line)
        
        line = leadingPaddingString + "   "
        for c in 1...cols {
            digit = c%10
            line += "\(digit) "
        }
        
        print(line)
        
        for r in 0...rows+1 {
            line = ""

            if r == 0 || r == rows+1 {
                line += leadingPaddingString
            } else {
                line += String(r).leftPadding(toLength: leadingPadding)
            }
            
            for c in 0...cols+1 {
                switch board[r][c] {
                case .empty:
                    line += "  "
                case .hit:
                    line += "💥"
                case .ship:
                    line += "🛳"
                case .shot:
                    line += "💣"
                case .none:
                    line += "  "
                case .notAllowed:
                    line += "  "
                case .water:
                    line += "🌊"
                }
            }
            
            print(line)
        }
    }
}
