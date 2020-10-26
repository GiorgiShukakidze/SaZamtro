//
//  Cart.swift
//  SaZamtro
//
//  Created by Giorgi Shukakidze on 8/6/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import Foundation

class Cart {
    private var items = [Item]()
    let shared = Cart()
    var totalPrice: Double {
        var sum = 0.0
        for item in items {
            sum += item.itemDetails.price
        }
        return sum
    }
    
    func itemsInCart() -> [Item] {
        return items
    }
    
    func item(at index: Int) -> Item? {
        if index < items.count {
            return items[index]
        } else {
            return nil
        }
    }
    
    func addToCart(item: Item) {
        items.append(item)
    }
    
    func emptyCart() {
        items.removeAll()
    }
}
