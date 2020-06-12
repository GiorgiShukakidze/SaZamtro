//
//  Item.swift
//  SaZamtro
//
//  Created by Giorgi Shukakidze on 6/9/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import Foundation

struct Item {
    var images: [String]
    var mainImage: String? {
        return images.first
    }
    let availableSizes: [String]
    let price: Double
    var discountedPrice: Double {
        return price - discount
    }
    var discount: Double {
        get {
            price * discountPercentage
        }
        set {
            discountPercentage = newValue / price
        }
    }
    var discountPercentage: Double {
        get {
            discount / price
        }
        set {
            discount = price * newValue
        }
    }
    let description: String
    let title: String
    let brand: String
}
