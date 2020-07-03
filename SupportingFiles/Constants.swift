//
//  Constants.swift
//  SaZamtro
//
//  Created by Giorgi Shukakidze on 6/17/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import Foundation

struct FBase {
    static let itemsCollection = "items"
    static func imageUrl(named imageName: String) -> String {
        return "gs://sazamtro-98455.appspot.com/images/\(imageName).jpg"
    }
}

struct ItemConstants {
    static let defaultImage = "notFound"
    static let brandText = "ბრენდი"
    static let priceText = "ფასი"
    static let sizeText = "ზომა"
    static let shortCurrencyText = "ლ"
    static let longCurrencyText = "ლარი"
    static let itemCellIdentifier = "sellItem"
}

struct ViewConstants {
    static let segueIdentifier = "itemDetails"
}
