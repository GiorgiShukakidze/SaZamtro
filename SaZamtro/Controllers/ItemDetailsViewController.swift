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
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var itemSize: UILabel!
    @IBOutlet weak var itemBrand: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBAction func addToCart(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addToCartButton.layer.cornerRadius = addToCartButton.frame.height/2
        if let item = shopItem {
            if let mainImage = item.mainImage {
                itemImage.image = UIImage(named: mainImage)
            }
            title = item.title
            itemBrand.text = "ბრენდი: \(item.brand)"
            itemPrice.text = "ფასი: \(item.price) ლარი"
            itemSize.text = "ზომა: \(item.availableSizes.first!)"
            itemDescription.text = item.description
        }
    }

}
