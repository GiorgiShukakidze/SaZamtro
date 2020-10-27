//
//  CartViewController.swift
//  SaZamtro
//
//  Created by wandio on 10/27/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {
    
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    @IBOutlet weak var emptyCart: UILabel!
    @IBOutlet weak var buyButton: UIButton! {
        didSet {
            buyButton.layer.cornerRadius = buyButton.frame.height/2
        }
    }
    
    private let cart = Cart.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        setupView()
    }
    
    
    // MARK: - IBOutlets
    @IBAction func didTapFacebook(_ sender: UIButton) {
        if let fbURL = URL(string: ExternalLinks.fbAppLink),
            let fbWebURL = URL(string: ExternalLinks.fbWebLink)
        {
            switch true {
            case UIApplication.shared.canOpenURL(fbURL):
                // Open page in Facebook app
                UIApplication.shared.open(fbURL, options: [:], completionHandler: nil)
            default:
                //redirect to safari because the user doesn't have Facebook
                UIApplication.shared.open(fbWebURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func didTapAbout(_ sender: UIButton) {
    }
    
    @IBAction func didTapMore(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func didTapBuy(_ sender: UIButton) {
    }
    
    private func setupView() {
        updateBuyButton()
        emptyCart.isHidden = cart.itemsInCart().count != 0
    }
    
    private func updateBuyButton() {
        if cart.itemsInCart().count > 0 {
            buyButton.isEnabled = true
            buyButton.setTitle("  BUY: \(cart.totalPrice) \(ItemConstants.shortCurrencyText)", for: .normal)
            buyButton.alpha = 1
        } else {
            buyButton.isEnabled = false
            buyButton.setTitle("  BUY", for: .disabled)
            buyButton.alpha = 0.5
        }
    }
}

extension CartViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let d: CGFloat = ViewConstants.cellInsetSpacing
        let width = (itemsCollectionView.frame.width - d) / 2
        let height = width * CGFloat(ViewConstants.cellHeightToWidthRatio)
        
        return CGSize(width: width, height: height)
    }
}

extension CartViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cart.itemsInCart().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CartCollectionViewCell", for: indexPath) as? CartCollectionViewCell {
            cell.setItem(at: indexPath.row)
            cell.delegate = self
            return cell
        }
        return UICollectionViewCell()
    }
}

extension CartViewController: CartCollectionViewCellDelegate {
    func didTapRemove(at index: Int) {
        cart.removeItem(at: index)
        itemsCollectionView.reloadData()
        setupView()
    }
}
