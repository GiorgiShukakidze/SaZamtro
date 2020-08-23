//
//  FirstViewController.swift
//  SaZamtro
//
//  Created by Giorgi Shukakidze on 5/24/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {
    
    private var selectedItem: Item?
    private lazy var itemsViewModel = ItemsViewModel()
    let cart = Cart()
    
    //MARK: - IB Outlets
    @IBOutlet private weak var itemsCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet var footerViews: [UIView]!
    
    override func viewDidLoad() {
        activityIndicator.startAnimating()
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        itemsViewModel.delegate = self
        navigationController?.navigationBar.isHidden = true
        
        DownloadManager.shared.authenticate { (success) in
            if success {
                self.itemsViewModel.getItems()
            } else {
                self.displayErrorView()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addSaleView()
    }
    
    @IBAction func facebookTapped(_ sender: UIButton) {
        
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
    
    @IBAction func aboutUsTapped(_ sender: UIButton) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let shopItem = selectedItem,
            segue.identifier == ViewConstants.segueIdentifier {
            
            let destinationVC = segue.destination as! ItemDetailsViewController
            destinationVC.shopItem = shopItem
        }
    }
    
    //MARK: - Utilities
    private func noInternetAlert() {
        let alert = UIAlertController(title: "Oops!", message: "No internet connection. :(", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func displayErrorView() {
        let errorView = ConnectionErrorView(frame: view.frame)
        view.addSubview(errorView)
        errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        errorView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        errorView.setupConstraints()
        errorView.retryButton.addTarget(self, action: #selector(retry), for: .touchUpInside)
        headerView.isHidden = true
        footerViews.forEach{ $0.isHidden = true }
    }
    
    private func addSaleView() {
        let saleView = SaleView()
        itemsCollectionView.contentInset.top = saleView.frame.height + ViewConstants.headerToCollectionViewSpacing
        saleView.frame.origin.y = -saleView.frame.height - ViewConstants.headerToCollectionViewSpacing
        itemsCollectionView.addSubview(saleView)
        saleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saleView.shopNowButton.addTarget(self, action: #selector(shopNow(_:)), for: .touchUpInside)
    }
    
    @objc func shopNow(_ sender: Any?) {
        print("SHoooop Noooow!")
    }
    
    @objc func retry(_ sender: Any?) {
        self.activityIndicator.startAnimating()
        if let button = sender as? UIButton, let errorView = button.superview {
            errorView.isHidden = true
            headerView.isHidden = false
            footerViews.forEach { $0.isHidden = false }
            itemsViewModel.getItems()
        }
    }
}

//MARK: - ItemsViewModel delegate methods
extension ItemListViewController: ItemsViewModelDelegate {
    
    func itemsFetchDidCompleteWithResult() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
        
            self.activityIndicator.stopAnimating()
            self.itemsCollectionView.isHidden = false
            self.itemsCollectionView.reloadData()
        }
    }
    
    func itemsFetchDidCompleteWithError() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.activityIndicator.stopAnimating()

            if self.itemsViewModel.numberOfItems() > 0 {
                self.noInternetAlert()
            } else {
                self.displayErrorView()
                self.itemsCollectionView.isHidden = true
            }
        }
    }
    
    func didFinishFetchingImage(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        if let cell = itemsCollectionView.cellForItem(at: indexPath) as? SellItemCell {
            cell.itemImage.setImageAnimated(with: itemsViewModel.item(at: index).itemImage.image!)
        }
    }
}

//MARK: - Collection view delegate methods
extension ItemListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = itemsViewModel.item(at: indexPath.item)
        
        performSegue(withIdentifier: ViewConstants.segueIdentifier, sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if itemsViewModel.numberOfItems() - 1 == indexPath.item {
            itemsViewModel.getItems(currentItem: itemsViewModel.item(at: indexPath.item))
        }
    }
}

//MARK: - Collection view data source methods
extension ItemListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsViewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemConstants.itemCellIdentifier,
                                                      for: indexPath) as! SellItemCell
                
        if itemsViewModel.numberOfItems() != 0 {
            cell.itemImage.image = nil
            let shopItem = itemsViewModel.item(at: indexPath.item)
            cell.itemPrice.text = "\(ItemConstants.shortCurrencyText)\(shopItem.itemDetails.price)"
//            cell.itemSize.text = shopItem.itemDetails.availableSizes.first!
            cell.itemName.text = shopItem.itemDetails.title
                    
            switch shopItem.itemImage.state {
            case .downloaded:
                DispatchQueue.main.async {
                    cell.itemImage.image = shopItem.itemImage.image
                }
            case .failed, .new:
                itemsViewModel.getItemImage(at: indexPath.item)
            default:
                break
            }
        }
        
        return cell
    }
}

//MARK: - Collection view delegate flow layout methods
extension ItemListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let d: CGFloat = ViewConstants.cellInsetSpacing
        let width = (itemsCollectionView.frame.width - d) / 2
        let height = width * CGFloat(ViewConstants.cellHeightToWidthRatio)
        
        return CGSize(width: width, height: height)
    }
}

//MARK: - Image view extension for animation
extension UIImageView {
    func setImageAnimated(with image: UIImage) {
        UIView.transition(with: self,
                          duration: 0.4,
                          options: [.curveEaseInOut, .transitionCrossDissolve],
                          animations: {
                            self.image = image
        },
                          completion: nil)
    }
}
