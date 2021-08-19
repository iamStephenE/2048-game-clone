//
//  GameManager.swift
//  2048-game
//
//  Created by Stephen Ebrahim on 8/18/21.
//

import SwiftUI

struct GameManager {
    
    var board = [[Tile]]()
    let boardView: UIView
    
    var dimension: Int
    let spacing: Int
    
    let DURATION: Double = 0.1
    
    var updatedBoard: Bool = false
    
    init(boardView: UIView, dimension: Int, spacing: Int, storedBoard: [[Int]], first: Bool) {
        self.boardView = boardView
        self.dimension = dimension
        self.spacing = spacing
        self.initializeBoard(using: storedBoard, first: first, theme: "classic")
    }
    
    mutating func initializeBoard(using storedBoard: [[Int]], first: Bool, theme: String) {
        board = []
        dimension = storedBoard.count
        for view in boardView.subviews {
            view.removeFromSuperview()
        }
        
        for r in 0..<dimension {
            var row: [Tile] = []
            for c in 0..<dimension {
                let newTile = Tile(row: r, col: c, value: storedBoard[r][c], boardView.frame, dimension, spacing, theme)
                row.append(newTile)
                boardView.addSubview(newTile.view)
            }
            board.append(row)
        }
        if first {
            fillRandomPosition()
            fillRandomPosition()
        }
        renderGame()
    }
    
    func renderGame() {
        for i in 0..<dimension {
            for j in 0..<dimension {
                if (board[i][j].value != 0) {
                    board[i][j].view.alpha = 0.1
                    UIView.animate(withDuration: DURATION) {
                        board[i][j].view.alpha = 1
                    }
                }
            }
        }
    }
    
    mutating func fillRandomPosition() {
        var i = Int.random(in: 0..<dimension)
        var j = Int.random(in: 0..<dimension)
        while(board[i][j].value != 0) {
            i = Int.random(in: 0..<dimension)
            j = Int.random(in: 0..<dimension)
        }
        board[i][j].setValue(1)
    }
    
}

// MARK: - Common Between Swipes

extension GameManager {
    mutating func respondToSwipeGesture(_ swipeGesture: UISwipeGestureRecognizer) {

        switch swipeGesture.direction {
        case .right:
            swipedHorizontally(from: 0, to: board.count, increment: 1)
        case .down:
            swipedVertically(from: 0, to: board.count, increment: 1)
        case .left:
            swipedHorizontally(from: board.count, to: 0, increment: -1)
        case .up:
            swipedVertically(from: board.count, to: 0, increment: -1)
        default:
            break
        }
    }
    
    func animate(_ fake: Tile, toX: Int, toY: Int) {
        UIView.animate(withDuration: DURATION) {
            fake.view.frame = board[toY][toX].view.frame
        }
    }
}

// MARK: - Horizontal Swipe

extension GameManager {
    
    func hasHorizontalAdjacent(_ i: Int) -> Bool {
        for j in 0..<board.count-1 {
            if board[i][j].value != 0 && board[i][j].value == board[i][j+1].value {
                return true
            }
        }
        return false
    }
    
    func legalHorizontalSwipe(from: Int, to: Int, increment: Int) -> Bool {
        for i in 0..<board.count {
            var hasOne = false
            for j in stride(from: from > board.count-1 ? board.count - 1 : from, to: to == 0 ? -1 : to, by: increment) {
                if board[i][j].value == 0 {
                    if hasOne {
                        return true
                    }
                } else {
                    hasOne = true
                }
            }
            if hasHorizontalAdjacent(i) {
                return true
            }
        }
        return false
    }
    
    mutating func shiftHorizontally(row: Int, col: Int, to end: Int, increment: Int) {
        var i: Int = col
        var destination: Int = col
        
        let fake = Tile(row: row, col: col, value: board[row][col].value, boardView.frame, dimension, spacing, board[row][col].theme)
        let begVal = board[row][col].value
        
        let comparisonOperator: (Int, Int) -> Bool = increment == -1 ? (>) : (<)
        
        while comparisonOperator(i, end-1 > -1 ? end-1 : 0) {
            if board[row][i + increment].value == 0 {
                board[row][i + increment].setValue(board[row][i].value)
                board[row][i].setValue(0)
                destination = i + increment
            } else if board[row][i].value == board[row][i + increment].value {
                board[row][i + increment].setValue(board[row][i + increment].value + 1)
                board[row][i].setValue(0)
                destination = i + increment
                i += increment
            }
            i += increment
        }
        
        let endVal = board[row][destination].value
        
        boardView.addSubview(fake.view)
        
        board[row][destination].setValue(begVal)
        animate(fake, toX: destination, toY: row)
        DispatchQueue.main.asyncAfter(deadline: .now() + DURATION * 3 / 4) {
            fake.view.removeFromSuperview()
        }
        board[row][destination].setValue(endVal)
    }
    
    mutating func swipedHorizontally(from: Int, to: Int, increment: Int) {
        if legalHorizontalSwipe(from: from, to: to, increment: increment) {
            updatedBoard = true
            for i in 0..<board.count {
                let trueFrom = to-1 > -1 ? to-1 : 0
                let trueTo = from == 0 ? -1: from
                for j in stride(from: trueFrom, to: trueTo, by: -increment) {
                    if board[i][j].value != 0 {
                        shiftHorizontally(row: i, col: j, to: to, increment: increment)
                    }
                }
            }
            fillRandomPosition()
            renderGame()
        } else {
            updatedBoard = false
            print("Cannot swipe horizontally")
        }
    }
}

// MARK: - Vertical Swipe

extension GameManager {
    
    func hasVerticalAdjacent(_ i: Int) -> Bool {
        for j in 0..<board.count-1 {
            if board[j][i].value != 0 && board[j][i].value == board[j+1][i].value {
                return true
            }
        }
        return false
    }
    
    func legalVerticalSwipe(from: Int, to: Int, increment: Int) -> Bool {
        for i in 0..<board.count {
            var hasOne = false
            for j in stride(from: from > board.count-1 ? board.count - 1 : from, to: to == 0 ? -1 : to, by: increment) {
                if board[j][i].value == 0 {
                    if hasOne {
                        return true
                    }
                } else {
                    hasOne = true
                }
            }
            if hasVerticalAdjacent(i) {
                return true
            }
        }
        return false
    }
    
    mutating func shiftVertically(row: Int, col: Int, to end: Int, increment: Int) {
        var i: Int = row
        var destination: Int = row
        
        let fake = Tile(row: row, col: col, value: board[row][col].value, boardView.frame, dimension, spacing, board[row][col].theme)
        let begVal = board[row][col].value
        
        let comparisonOperator: (Int, Int) -> Bool = increment == -1 ? (>) : (<)
        
        while comparisonOperator(i, end-1 > -1 ? end-1 : 0) {
            if board[i + increment][col].value == 0 {
                board[i + increment][col].setValue(board[i][col].value)
                board[i][col].setValue(0)
                destination = i + increment
            } else if board[i][col].value == board[i + increment][col].value {
                board[i + increment][col].setValue(board[i + increment][col].value + 1)
                board[i][col].setValue(0)
                destination = i + increment
                i += increment
            }
            
            i += increment
        }
        
        let endVal = board[destination][col].value
        
        boardView.addSubview(fake.view)
        
        board[destination][col].setValue(begVal)
        animate(fake, toX: col, toY: destination)
        DispatchQueue.main.asyncAfter(deadline: .now() + DURATION * 3 / 4) {
            fake.view.removeFromSuperview()
        }
        board[destination][col].setValue(endVal)
    }
    
    mutating func swipedVertically(from: Int, to: Int, increment: Int) {
        if legalVerticalSwipe(from: from, to: to, increment: increment) {
            updatedBoard = true
            for i in 0..<board.count {
                let trueFrom = to-1 > -1 ? to-1 : 0
                let trueTo = from == 0 ? -1: from
                for j in stride(from: trueFrom, to: trueTo, by: -increment) {
                    if board[j][i].value != 0 {
                        shiftVertically(row: j, col: i, to: to, increment: increment)
                    }
                }
            }
            fillRandomPosition()
            renderGame()
        } else {
            updatedBoard = false
            print("Cannot swipe vertically")
        }
    }
}
