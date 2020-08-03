//
//  ItemDetailsViewController.swift
//  SaZamtro
//
//  Created by Giorgi Shukakidze on 5/25/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class ItemDetailsViewController: UIViewController {
    
    var shopItem: Item?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var itemImage: UIImageView! {
        didSet {
            itemImage.layer.cornerRadius = 20
        }
    }
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var itemSize: UILabel!
    @IBOutlet weak var itemBrand: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var nothingToShow: UIView! {
        didSet {
            nothingToShow.isHidden = true
        }
    }
    @IBAction func addToCart(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addToCartButton.layer.cornerRadius = addToCartButton.frame.height/2
        if let item = shopItem {
            if let mainImage = item.itemImage.image {
                itemImage.image = mainImage
            }
            title = item.itemDetails.title
            itemBrand.text = "\(ItemConstants.brandText): \(item.itemDetails.brand)"
            itemPrice.text = "\(ItemConstants.priceText): \(item.itemDetails.price) \(ItemConstants.longCurrencyText)"
            itemSize.text = "\(ItemConstants.sizeText): \(item.itemDetails.availableSizes.first!)"
            itemDescription.text = item.itemDetails.description
        } else {
            nothingToShow.isHidden = false
        }
    }

}
