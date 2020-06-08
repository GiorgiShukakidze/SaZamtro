//
//  ItemDetailsViewController.swift
//  SaZamtro
//
//  Created by Giorgi Shukakidze on 5/25/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class ItemDetailsViewController: UIViewController {
    
    var viewImage = UIImage()
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemSize: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBAction func addToCart(_ sender: UIButton) {
    }
    @IBAction func back(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addToCartButton.layer.cornerRadius = 10
        itemImage.image = viewImage
    }

}
