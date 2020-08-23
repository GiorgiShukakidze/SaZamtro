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
    @IBOutlet weak var itemName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpCell()
    }
    
    func setUpCell() {
        layer.cornerRadius = ViewConstants.imageCornerRadius
        itemImage.layer.cornerRadius = ViewConstants.imageCornerRadius
        itemImage.contentMode = .scaleAspectFit
    }
}
