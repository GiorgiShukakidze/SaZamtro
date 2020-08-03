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
    
    //MARK: - IB Outlets
    @IBOutlet private weak var itemsCollectionView: UICollectionView!
    @IBOutlet private weak var errorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBAction private func retryTapped(_ sender: UIButton) {
        self.activityIndicator.stopAnimating()
        errorView.isHidden = true
        itemsViewModel.getItems()
    }
    
    override func viewDidLoad() {
        activityIndicator.startAnimating()
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        itemsViewModel.delegate = self
        
        errorView.isHidden = true
        itemsViewModel.getItems()
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
}

//MARK: - ItemsViewModel delegate methods
extension ItemListViewController: ItemsViewModelDelegate {
    
    func itemsFetchDidCompleteWithResult() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
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
                self.errorView.isHidden = false
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
        //  TO DO
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
            cell.itemPrice.text = "\(shopItem.itemDetails.price) \(ItemConstants.shortCurrencyText)"
            cell.itemSize.text = shopItem.itemDetails.availableSizes.first!
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
        let d: CGFloat = 20
        let heightToWidthRatio = 1.5
        let width = (itemsCollectionView.frame.width - d) / 2
        let height = width * CGFloat(heightToWidthRatio)
        
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
