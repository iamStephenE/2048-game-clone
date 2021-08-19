//
//  TilesState.swift
//  2048-game
//
//  Created by Stephen Ebrahim on 8/19/21.
//

import SwiftUI
import RealmSwift

// work around for creating a 2d array and storing it in realm
class TilesState: Object {
    let board = RealmSwift.List<TilesRow>()
}

class TilesRow: Object {
    let row = RealmSwift.List<Int>()
}
