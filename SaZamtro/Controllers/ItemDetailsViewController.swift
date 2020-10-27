//
//  ItemDetailsViewController.swift
//  SaZamtro
//
//  Created by Giorgi Shukakidze on 5/25/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class ItemDetailsViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var shopItem: Item?
    var cart = Cart.shared
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var discountLabel: DiscountLabel!
    @IBOutlet weak var itemImage: UIImageView! {
        didSet {
            itemImage.layer.cornerRadius = ViewConstants.imageCornerRadius
        }
    }
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var itemSize: UILabel!
    @IBOutlet weak var itemBrand: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var cartImage: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupView() {
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        addToCartButton.layer.cornerRadius = addToCartButton.frame.height/2
        updateCart()
        if let item = shopItem {
            setupItemDetails(with: item)
        } else {
            DisplayNothingToShow()
        }
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateCart), name: NSNotification.Name(rawValue: Cart.NotificationKeys.cartDidChange), object: nil)
    }
    
    @objc func updateCart() {
        cartImage.image = cart.itemsInCart().count > 0 ? UIImage(named: "cart_full") : UIImage(named: "cart_empty")
    }
//    @objc func dis() {
//        dismiss(animated: true, completion: nil)
//    }
    
    @IBAction func addToCart(_ sender: UIButton) {
        if let selectedItem = shopItem {
            cart.addToCart(item: selectedItem)
        }
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
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
        discountLabel.isHidden = item.itemDetails.price > 100
        itemBrand.text = "\(item.itemDetails.brand)"
        itemPrice.text = "\(ItemConstants.shortCurrencyText)\(item.itemDetails.price) "
        itemSize.text = "\(item.itemDetails.availableSizes.first!)"
        itemDescription.text = item.itemDetails.title
    }
    
    private func DisplayNothingToShow() {
        scrollView.isHidden = true
        
        let label = UILabel(frame: CGRect.zero)
        label.text = TextConstants.nothingToShowText
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
