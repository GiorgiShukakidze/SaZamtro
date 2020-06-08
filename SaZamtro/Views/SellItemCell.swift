//
//  SellItemCollectionViewCell.swift
//  SaZamtro
//
//  Created by Giorgi Shukakidze on 5/24/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class SellItemCell: UICollectionViewCell {
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var itemSize: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 10
        itemImage.layer.cornerRadius = 10
        addToCartButton.layer.cornerRadius = 8
    }
    
    func setUpCell(with card: UIImage) {
        itemImage.image = card
        itemImage.contentMode = .scaleAspectFit
        addToCartButton.bounds.size = CGSize(width: 500, height: 500)
    }
}
