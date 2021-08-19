//
//  TileView.swift
//  2048-game
//
//  Created by Stephen Ebrahim on 8/18/21.
//

import SwiftUI

struct TileView {
    
    let boardView: CGRect
    
    let dimension: Int
    let spacing: Int
    
    let tileDimension: CGFloat
    
    init(_ boardView: CGRect, _ dimension: Int, _ spacing: Int) {
        self.boardView = boardView
        self.dimension = dimension
        self.spacing = spacing
        
        self.tileDimension = (boardView.width - CGFloat(spacing * (dimension + 1))) / CGFloat(dimension)
    }
    
    func create(_ i: Int, _ j: Int, value: Int, _ theme: String) -> UIView {
        let newX: CGFloat = CGFloat((j + 1) * spacing) + CGFloat(j) * tileDimension
        let newY: CGFloat = CGFloat((i + 1) * spacing) + CGFloat(i) * tileDimension
        
        let rect = CGRect(x: newX,
                          y: newY,
                          width: tileDimension,
                          height: tileDimension)
        
        let newTile = UIView(frame: rect)
        
        let tileProperties = TileProperties(of: value, withTheme: theme)
        
        newTile.backgroundColor = tileProperties.getColor()
        
        newTile.addSubview(tileProperties.getLabel(withSize: tileDimension, tile: newTile))
        newTile.layer.cornerRadius = newTile.frame.height / 10
        
        return newTile
    }
    
}
