//
//  Cart.swift
//  SaZamtro
//
//  Created by Giorgi Shukakidze on 8/6/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import Foundation

class Cart {
    struct NotificationKeys {
        static let cartDidChange = "cartDidChange"
    }
    
    static let shared = Cart()

    private var items = [Item]()
        
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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationKeys.cartDidChange), object: nil)
    }
    
    func removeItem(at index: Int) {
        guard index < items.count else { return }
        items.remove(at: index)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationKeys.cartDidChange), object: nil)
    }
    
    func emptyCart() {
        items.removeAll()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationKeys.cartDidChange), object: nil)
    }
}
