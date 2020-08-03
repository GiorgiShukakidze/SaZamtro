//
//  Item.swift
//  SaZamtro
//
//  Created by Giorgi Shukakidze on 8/3/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import Foundation

struct Item: Equatable {
    
    let itemDetails: ItemDetails
    var itemImage: ItemImage
    let id = UUID()
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        lhs.id == rhs.id
    }
}
