//
//  ItemImage.swift
//  SaZamtro
//
//  Created by Giorgi Shukakidze on 6/24/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

enum ImageRecordState {
    case new, pending, downloaded, failed
}

struct ItemImage {
    let name: String
    let url: String
    var state = ImageRecordState.new
    var image: UIImage?
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}
