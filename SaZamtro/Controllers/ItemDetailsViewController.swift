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
    var cart: Cart?
    
    //MARK: - IBOutlets
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addToCartButton.layer.cornerRadius = addToCartButton.frame.height/2
        if let item = shopItem {
            setupItemDetails(with: item)
        } else {
            DisplayNothingToShow()
        }
    }
    
    @IBAction func addToCart(_ sender: UIButton) {
    }
    
//MARK: - Utilities
    
    private func setupItemDetails(with item: Item) {
        
        if let mainImage = item.itemImage.image {
            itemImage.image = mainImage
        } else if let imageUrl = item.itemDetails.mainImage {
            
            DownloadManager.shared.fetchImage(named: imageUrl) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.itemImage.image = image
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        title = item.itemDetails.title
        itemBrand.text = "\(ItemConstants.brandText): \(item.itemDetails.brand)"
        itemPrice.text = "\(ItemConstants.priceText): \(item.itemDetails.price) \(ItemConstants.longCurrencyText)"
        itemSize.text = "\(ItemConstants.sizeText): \(item.itemDetails.availableSizes.first!)"
        itemDescription.text = item.itemDetails.description
    }
    
    private func DisplayNothingToShow() {
        scrollView.isHidden = true
        
        let label = UILabel(frame: CGRect.zero)
        label.text = "Nothing to show...\nPlease retry."
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = #colorLiteral(red: 0.4039215686, green: 0.6078431373, blue: 0.6078431373, alpha: 1)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
