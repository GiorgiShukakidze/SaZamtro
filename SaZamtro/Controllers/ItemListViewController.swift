//
//  FirstViewController.swift
//  SaZamtro
//
//  Created by Giorgi Shukakidze on 5/24/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {
    
    var selectedItem: Item?
    var selectedImage: UIImage?
    let itemsViewModel = ItemsViewModel()
    
    //MARK: - IB Outlets
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    @IBOutlet weak var errorView: UIView!
    @IBAction func retryTapped(_ sender: UIButton) {
        errorView.isHidden = true
        itemsViewModel.getItems(isRefresh: true)
    }
    
    override func viewDidLoad() {
        
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        itemsCollectionView.prefetchDataSource = self
        itemsViewModel.delegate = self
        
        errorView.isHidden = true
        itemsViewModel.getItems()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let shopItem = selectedItem,
            let itemImage = selectedImage,
            segue.identifier == ViewConstants.segueIdentifier {
            
            let destinationVC = segue.destination as! ItemDetailsViewController
            destinationVC.shopItem = shopItem
            destinationVC.shopItemImage = itemImage
        }
    }
    
    //MARK: - Utilities
    func noInternetAlert() {
        let alert = UIAlertController(title: "Oops!", message: "No internet connection. :(", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - ItemsViewModel delegate methods
extension ItemListViewController: ItemsViewModelDelegate {
    func itemsFetchDidCompleteWithResult() {
        DispatchQueue.main.async {
//            self.itemsCollectionView.refreshControl?.endRefreshing()
            self.itemsCollectionView.reloadData()
        }
        
        for index in 0..<self.itemsViewModel.numberOfItems() {
            if let imageUrl = itemsViewModel.item(at: index).mainImage {
                
                let imageObject = ItemImage(name: itemsViewModel.item(at: index).title, url: imageUrl)
                self.itemsViewModel.addItemImageObject(imageObject)
                self.itemsViewModel.getItemImage(at: index)
            }
        }
    }
    
    func itemsFetchDidCompleteWithError() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
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
        self.itemsCollectionView.reloadItems(at: [indexPath])
    }
}

//MARK: - Collection view delegate methods
extension ItemListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem = itemsViewModel.item(at: indexPath.item)
        selectedImage = itemsViewModel.itemImage(at: indexPath.item).image
        
        performSegue(withIdentifier: ViewConstants.segueIdentifier, sender: self)
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
            let shopItem = itemsViewModel.item(at: indexPath.item)
            cell.itemPrice.text = "\(shopItem.price) \(ItemConstants.shortCurrencyText)"
            cell.itemSize.text = shopItem.availableSizes.first
            cell.itemName.text = shopItem.title
            
            let imageObject = itemsViewModel.itemImage(at: indexPath.item)
            
            switch imageObject.state {
            case .downloaded:
                DispatchQueue.main.async {
                    cell.itemImage.setImageAnimated(with: imageObject.image!)
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

//MARK: - Collection view data source prefetching methods
extension ItemListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if itemsViewModel.numberOfItems() != 0 {
            for indexPath in indexPaths {
                let imageObject = itemsViewModel.itemImage(at: indexPath.item)
                
                if imageObject.state == .new || imageObject.state == .failed {
                    itemsViewModel.getItemImage(at: indexPath.item)
                }
            }
        }
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
