//
//  Item.swift
//  SaZamtro
//
//  Created by Giorgi Shukakidze on 6/9/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import Foundation

struct Item: Codable, Equatable {
    var id: UUID?
    var images: [String]
    let description: String
    let title: String
    let brand: String
    let availableSizes: [String]
    let price: Double
    
    var mainImage: String? {
        return images.first
    }
    
// TO DO
    
//    var discountedPrice: Double {
//        return price - discount
//    }
//    var discount: Double {
//        get {
//            price * discountPercentage
//        }
//        set {
//            discountPercentage = newValue / price
//        }
//    }
//    var discountPercentage: Double {
//        get {
//            discount / price
//        }
//        set {
//            discount = price * newValue
//        }
//    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case images
        case description
        case title
        case brand
        case availableSizes
        case price
    }
}
