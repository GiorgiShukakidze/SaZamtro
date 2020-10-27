//
//  CartCollectionViewCell.swift
//  SaZamtro
//
//  Created by wandio on 10/27/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

protocol CartCollectionViewCellDelegate {
    func didTapRemove(at index: Int)
}

class CartCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var discountLabel: DiscountLabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemName: UILabel!
    
    private var cart = Cart.shared
    private var itemIndex: Int? {
        didSet {
            if let index = itemIndex {
                item = cart.item(at: index)
            }
        }
    }
    private var item: Item? {
        didSet {
            setup(with: item)
        }
    }
    
    var delegate: CartCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    func setItem(at index: Int) {
        itemIndex = index
    }
    
    private func setupCell() {
        layer.cornerRadius = ViewConstants.imageCornerRadius
        itemImage.layer.cornerRadius = ViewConstants.imageCornerRadius
        itemImage.contentMode = .scaleAspectFit
    }
    
    private func setup(with item: Item?) {
        guard let item = item else { return }
        itemName.text = item.itemDetails.title
        itemPrice.text = "\(ItemConstants.shortCurrencyText)\(item.itemDetails.price)"
        discountLabel.isHidden = item.itemDetails.price > 100
        
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
    }
    
    @IBAction private func didTapRemove(_ sender: UIButton) {
        if let index = itemIndex {
            delegate?.didTapRemove(at: index)
        }
    }
}
