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
    var shopItemImage: UIImage?
    
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
            if let mainImage = shopItemImage {
                itemImage.image = mainImage
            }
            title = item.title
            itemBrand.text = "\(ItemConstants.brandText): \(item.brand)"
            itemPrice.text = "\(ItemConstants.priceText): \(item.price) \(ItemConstants.longCurrencyText)"
            itemSize.text = "\(ItemConstants.sizeText): \(item.availableSizes.first!)"
            itemDescription.text = item.description
        } else {
            nothingToShow.isHidden = false
        }
    }

}
