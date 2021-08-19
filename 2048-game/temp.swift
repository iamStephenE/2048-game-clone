//
//  temp.swift
//  2048-game
//
//  Created by Stephen Ebrahim on 8/18/21.
//

import Foundation

/*
 //
 //  ViewController.swift
 //  2048-game
 //
 //  Created by Stephen Ebrahim on 8/17/21.
 //

 import UIKit

 class ViewController: UIViewController {

     @IBOutlet weak var component: UIView!
     
     let screenSize: CGRect = UIScreen.main.bounds
     var yDir = -1;
     var xDir = 1;
     
     override func viewDidLayoutSubviews() {
         component.frame = CGRect(x: 0, y: -component.frame.height, width: component.frame.width, height: component.frame.height)
     }
     
     override func viewDidLoad() {
         super.viewDidLoad()
         // Do any additional setup after loading the view.
         
         let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
         swipeRight.direction = .right
         self.view.addGestureRecognizer(swipeRight)

         let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
         swipeDown.direction = .down
         self.view.addGestureRecognizer(swipeDown)
         
         let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
         swipeLeft.direction = .left
         self.view.addGestureRecognizer(swipeLeft)
         
         let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
         swipeUp.direction = .up
         self.view.addGestureRecognizer(swipeUp)
     }

     @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

         if let swipeGesture = gesture as? UISwipeGestureRecognizer {
             
             var x = 0;
             var y = 0;

             switch swipeGesture.direction {
             case .right:
                 print("Swiped right")
                 x = 1
             case .down:
                 print("Swiped down")
                 y = 1
             case .left:
                 print("Swiped left")
                 x = -1
             case .up:
                 print("Swiped up")
                 y = -1
             default:
                 break
             }
             
             let stepX = CGFloat(50 * x)
             let stepY = CGFloat(50 * y)
             
             UIView.animate(withDuration: 0.5) {
                 self.component.frame = CGRect(x: self.component.frame.minX + stepX,
                                               y: self.component.frame.minY + stepY,
                                               width: self.component.frame.width,
                                               height: self.component.frame.height)
             }
         }
     }
     
     @IBAction func moveButtonPressed(_ sender: Any) {
         animate(component);
         yDir *= -1
     }
     
     func animate(_ view: UIView!) {
         let centerX = (screenSize.width - view.frame.width) / 2
         let centerY = (screenSize.height - view.frame.height) / 2
         
         UIView.animate(withDuration: 1) {
             view.alpha = 0.7;
             view.frame = CGRect(x: centerX, y: centerY, width: view.frame.width, height: view.frame.height)
         }
     }


 }


 */


// older
/*
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
     
     let dimension: Int
     let spacing: Int
     
     let DURATION: Double = 0.1
     
     init(boardView: UIView, dimension: Int, spacing: Int) {
         self.boardView = boardView
         self.dimension = dimension
         self.spacing = spacing
         self.initializeBoard();
     }
     
     mutating func initializeBoard() {
         
         for view in boardView.subviews {
             view.removeFromSuperview()
         }
         
         board = []
         for r in 0..<dimension {
             var row: [Tile] = []
             for c in 0..<dimension {
                 let newTile = Tile(row: r, col: c, value: 0, boardView.frame, dimension, spacing)
                 row.append(newTile)
                 boardView.addSubview(newTile.view)
             }
             board.append(row)
         }
         
         fillRandomPosition()
         fillRandomPosition()
         renderGame()
     }
     
     func renderGame() {
         for i in 0..<dimension {
             for j in 0..<dimension {
                 if (board[i][j].value != 0) {
                     //print(board[i][j])
                     board[i][j].view.alpha = 0.1
                     UIView.animate(withDuration: DURATION) {
                         board[i][j].view.alpha = 1
                     }
                 }
             }
         }
     }
     
     mutating func fillRandomPosition() {
         var i = Int.random(in: 0..<dimension);
         var j = Int.random(in: 0..<dimension);
         while(board[i][j].value != 0) {
             i = Int.random(in: 0..<dimension);
             j = Int.random(in: 0..<dimension);
         }
         board[i][j].setValue(1)
     }
     
 }

 // MARK: - Common

 extension GameManager {
     mutating func respondToSwipeGesture(_ swipeGesture: UISwipeGestureRecognizer) {

         switch swipeGesture.direction {
         case .right:
             swipedHorizontally(from: 0, to: board.count, increment: 1)
         case .down:
             print("Swiped down")
         case .left:
             swipedHorizontally(from: board.count, to: 0, increment: -1)
         case .up:
             print("Swiped up")
         default:
             break
         }
     }
     
     func hasHorizontalAdjacent(_ i: Int) -> Bool {
         for j in 0..<board.count-1 {
             if board[i][j].value != 0 && board[i][j].value == board[i][j+1].value {
                 return true
             }
         }
         return false
     }
     
     func animate(_ fake: Tile, toX: Int, toY: Int) {
         UIView.animate(withDuration: DURATION) {
             fake.view.frame = board[toY][toX].view.frame
         }
     }
 }

 // MARK: - Right
 extension GameManager {
     
     func legalHorizontalSwipe(from: Int, to: Int, increment: Int) -> Bool {
         for i in 0..<board.count {
             var hasOne = false
             for j in stride(from: from > board.count-1 ? board.count - 1 : from, to: to == 0 ? -1 : to, by: increment) {
                 //print(j)
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
     
     /*func legalHorizontalSwipeRight() -> Bool {
         
         for i in 0..<board.count {
             var hasOne = false
             for j in 0..<board.count {
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
     }*/
     
     mutating func shiftHorizontally(row: Int, col: Int, to end: Int, increment: Int) {
         var i: Int = col
         var destination: Int = col
         
         let fake = Tile(row: row, col: col, value: board[row][col].value, boardView.frame, dimension, spacing)
         let begVal = board[row][col].value
         
         var comparisonOperator: (Int, Int) -> Bool
         if increment == -1 {
             comparisonOperator = (>)
         } else {
             comparisonOperator = (<)
         }
         
         while comparisonOperator(i, end-1 > -1 ? end-1 : 0) {
             //print(end-1)
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
     
     
     /*mutating func shiftRight(row: Int, col: Int) {
         var i: Int = col
         var destination: Int = col
         
         let fake = Tile(row: row, col: col, value: board[row][col].value, boardView.frame, dimension, spacing)
         let begVal = board[row][col].value
         
         while i < board.count-1 {
             if board[row][i+1].value == 0 {
                 board[row][i+1].setValue(board[row][i].value)
                 board[row][i].setValue(0)
                 destination = i + 1
             } else if board[row][i].value == board[row][i+1].value {
                 board[row][i+1].setValue(board[row][i+1].value + 1)
                 board[row][i].setValue(0)
                 destination = i + 1
                 i += 1
             }
             i += 1
         }
         
         let endVal = board[row][destination].value
         
         boardView.addSubview(fake.view)
         
         board[row][destination].setValue(begVal)
         animate(fake, toX: destination, toY: row)
         DispatchQueue.main.asyncAfter(deadline: .now() + DURATION * 3 / 4) {
             fake.view.removeFromSuperview()
         }
         board[row][destination].setValue(endVal)
         
     }*/
     
     mutating func swipedHorizontally(from: Int, to: Int, increment: Int) {
         if legalHorizontalSwipe(from: from, to: to, increment: increment) {
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
             print("Cannot swipe horizontally")
         }
     }
     
     /*mutating func swipedRight() {
         if (legalHorizontalSwipeRight()) {
             for i in 0..<board.count {
                 for j in stride(from: board.count-1, to: -1, by: -1) {
                     if board[i][j].value != 0 {
                         shiftRight(row: i, col: j)
                     }
                 }
             }
             fillRandomPosition()
             renderGame()
         } else {
             print("Cannot swipe right")
         }
     }*/
 }

 // MARK: - Left

 extension GameManager {
     
     func legalHorizontalSwipeLeft() -> Bool {
         for i in 0..<board.count {
             var hasOne = false
             for j in stride(from: board.count-1, to: -1, by: -1) {
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
     
     mutating func shiftLeft(row: Int, col: Int) {
         var i: Int = col
         var destination: Int = col
         
         let fake = Tile(row: row, col: col, value: board[row][col].value, boardView.frame, dimension, spacing)
         let begVal = board[row][col].value
         
         while i > 0 {
             if board[row][i-1].value == 0 {
                 board[row][i-1].setValue(board[row][i].value)
                 board[row][i].setValue(0)
                 destination = i - 1
             } else if board[row][i].value == board[row][i-1].value {
                 board[row][i-1].setValue(board[row][i-1].value + 1)
                 board[row][i].setValue(0)
                 destination = i - 1
                 i -= 1
             }
             i -= 1
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
     
     mutating func swipedLeft() {
         if (legalHorizontalSwipeLeft()) {
             for i in 0..<board.count {
                 for j in 0..<board.count {
                     if board[i][j].value != 0 {
                         shiftLeft(row: i, col: j)
                     }
                 }
             }
             fillRandomPosition()
             renderGame()
         } else {
             print("Cannot swipe left")
         }
     }
 }

 */
