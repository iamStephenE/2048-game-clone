//
//  TileView.swift
//  2048-game
//
//  Created by Stephen Ebrahim on 8/18/21.
//

import SwiftUI

struct Tile {
    
    var view: UIView!
    var theme: String
    
    var col: Int
    var row: Int
    var value: Int
    
    let xPos: CGFloat
    let yPos: CGFloat
    let tileDimension: CGFloat
    
    init(row: Int, col: Int, value: Int, _ boardView: CGRect, _ dimension: Int, _ spacing: Int, _ theme: String) {
        self.col = col
        self.row = row
        self.value = value
        self.theme = theme
        
        self.tileDimension = (boardView.width - CGFloat(spacing * (dimension + 1))) / CGFloat(dimension)
        
        self.xPos = CGFloat((col + 1) * spacing) + CGFloat(col) * tileDimension
        self.yPos = CGFloat((row + 1) * spacing) + CGFloat(row) * tileDimension
        
        self.view = self.createTileView(self.theme)
        
    }
    
    func createTileView(_ theme: String) -> UIView {
        let rect = CGRect(x: xPos,
                          y: yPos,
                          width: tileDimension,
                          height: tileDimension)
        
        let newTile = UIView(frame: rect)
        
        let tileProperties = TileProperties(of: value, withTheme: theme)
        newTile.backgroundColor = tileProperties.getColor()
        newTile.addSubview(tileProperties.getLabel(withSize: tileDimension, tile: newTile))
        
        newTile.layer.cornerRadius = newTile.frame.height / 10
        
        return newTile
    }
    
    mutating func setValue(_ value: Int) {
        self.value = value
        let tileProperties = TileProperties(of: value, withTheme: theme)
        view.backgroundColor = tileProperties.getColor()
        
        for v in view.subviews {
            v.removeFromSuperview()
        }
        
        view.addSubview(tileProperties.getLabel(withSize: tileDimension, tile: view))
    }
    
}
