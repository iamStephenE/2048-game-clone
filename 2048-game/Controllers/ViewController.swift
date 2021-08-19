//
//  ViewController.swift
//  2048-game
//
//  Created by Stephen Ebrahim on 8/17/21.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    let realm = try! Realm()

    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var gameBoard: UIView!
    
    var boardDimension: Int = 5
    var board = [[Int]]()
    var theme: String = "classic"
    
    var gameManager: GameManager?
    
    override func viewDidLayoutSubviews() {
        newGameButton.layer.cornerRadius = newGameButton.frame.height / 5
        gameBoard.layer.cornerRadius = gameBoard.frame.height / 25
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadStoredBoard()
        gameManager = GameManager(boardView: gameBoard, dimension: boardDimension, spacing: 7, storedBoard: board, first: realm.objects(TilesState.self).count == 0)
        saveBoardState(gameManager!.board)
        
        // acounting for all gestures
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.gameBoard.addGestureRecognizer(swipeRight)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        self.gameBoard.addGestureRecognizer(swipeDown)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = .left
        self.gameBoard.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeUp.direction = .up
        self.gameBoard.addGestureRecognizer(swipeUp)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            self.gameManager?.respondToSwipeGesture(swipeGesture)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if self.gameManager!.updatedBoard {
                    self.saveBoardState(self.gameManager!.board)
                    self.cleanRealm();
                }
            }
        }
    }
}

// MARK: - Handling Buttons Pressed & Segue

extension ViewController {
    @IBAction func newGamePressed(_ sender: UIButton) {
        deleteDatabase()
        loadStoredBoard()
        gameManager?.initializeBoard(using: board, first: true, theme: self.theme)
        saveBoardState(gameManager!.board)
    }
    
    @IBAction func undoPressed(_ sender: UIButton) {
        // remove the last state
        do {
            try realm.write {
                if realm.objects(TilesState.self).count > 1 {
                    realm.delete(realm.objects(TilesState.self).last!)
                    var deletedCount = 0
                    while deletedCount < boardDimension && realm.objects(TilesRow.self).count != 0 {
                        realm.delete(realm.objects(TilesRow.self).last!)
                        deletedCount += 1
                    }
                }
            }
        } catch {
            print("Error performing undo functionality")
        }
        loadStoredBoard()
        gameManager?.initializeBoard(using: board, first: false, theme: self.theme)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCustomization" {
            let destinationVC = segue.destination as! CustomizationViewController
            destinationVC.delegate = self
        }
    }
}

// MARK: - Handling Realm Database Operations

extension ViewController {
    func loadStoredBoard() {
        if (realm.objects(TilesState.self).count != 0) {
            board = convertRealmData(realm.objects(TilesState.self).last!)
        } else {
            board = [[Int]](repeating: ([Int](repeating: 0, count: boardDimension)), count: boardDimension)
        }
    }
    
    func convertRealmData(_ realmBoard: TilesState) -> [[Int]] {
        var result = [[Int]]()
        for i in 0..<realmBoard.board.count {
            var temp: [Int] = []
            for j in 0..<realmBoard.board[i].row.count {
                temp.append(realmBoard.board[i].row[j])
            }
            result.append(temp)
        }
        return result
    }
    
    func saveBoardState(_ board: [[Tile]]) {
        let tilesState = TilesState()
        for i in 0..<board.count {
            let tilesRow = TilesRow()
            for j in 0..<board.count {
                tilesRow.row.append(board[i][j].value)
            }
            tilesState.board.append(tilesRow)
        }
        
        do {
            try realm.write {
                realm.add(tilesState)
            }
        } catch {
            print("Error saving board state")
        }
    }
    
    func cleanRealm() {
        if realm.objects(TilesState.self).count > 20 {
            do {
                try realm.write {
                    realm.delete(realm.objects(TilesState.self)[0])
                    for _ in 0..<boardDimension {
                        realm.delete(realm.objects(TilesRow.self)[0])
                    }
                }
            } catch {
                print("error trying to clean data")
            }
        }
    }
    
    func deleteDatabase() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("Error deleting all of realm")
        }
    }
    
}

// MARK: - CustomizationDelegate

extension ViewController: CustomizationDelegate {
    func didCustomize(boardDimension: Int, theme: String) {
        self.boardDimension = boardDimension
        self.theme = theme
        deleteDatabase()
        loadStoredBoard()
        gameManager?.initializeBoard(using: board, first: true, theme: self.theme)
        saveBoardState(gameManager!.board)
    }
    
}

