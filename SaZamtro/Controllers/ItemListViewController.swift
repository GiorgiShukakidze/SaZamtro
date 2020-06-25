//
//  FirstViewController.swift
//  SaZamtro
//
//  Created by Giorgi Shukakidze on 5/24/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {
    
    var items = [Item]()
    var itemImages = [ItemImage]()
    var selectedItem: Item?
    var selectedImage: UIImage?
    let downloadManager = DownloadManager()
    
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        itemsCollectionView.prefetchDataSource = self
        getItems()
        configureRefreshControl()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let shopItem = selectedItem, let itemImage = selectedImage, segue.identifier == "itemDetails" {
            
            let destinationVC = segue.destination as! ItemDetailsViewController
            destinationVC.shopItem = shopItem
            destinationVC.shopItemImage = itemImage
        }
    }
    
    //MARK: - Configure Refresh control on pull
    
    func configureRefreshControl () {
        itemsCollectionView.refreshControl = UIRefreshControl()
        itemsCollectionView.refreshControl?.tintColor = #colorLiteral(red: 0.4039215686, green: 0.6078431373, blue: 0.6078431373, alpha: 1)
        itemsCollectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        // Update your content…
        print("refressshing")
        items = []
        itemImages = []
        getItems()
        
        // Dismiss the refresh control.
        DispatchQueue.main.async {
            self.itemsCollectionView.refreshControl?.endRefreshing()
        }
    }
    
    //MARK: - Get items and images
    
    func getItems(isRefresh: Bool = false) {

        downloadManager.fetchItems { [weak self] (items, error) in
            guard let self = self else { return }
            
            if error == nil {
                self.items = items
                self.itemsCollectionView.reloadData()

                for n in 0..<self.items.count {
                    if let imageUrl = items[n].mainImage {
                        let image = ItemImage(name: items[n].title, url: imageUrl)
                        self.itemImages.append(image)
                        self.getItemImage(at: n)
                        print("images \(self.itemImages.count) items \(self.items.count)")
                    }
                }
            }
        }
    }
    
    func getItemImage(at index: Int, section: Int = 0) {
        let imageObject = itemImages[index]
        
        switch imageObject.state {
        case .failed, .new:
            itemImages[index].state = .pending
            
            downloadManager.fetchImage(named: imageObject.url) { (image, error) in
                if error == nil {
                    self.itemImages[index].image = image
                    self.itemImages[index].state = .downloaded
                } else if let errorImage = UIImage(named: ItemConstants.defaultImage) {
                    self.itemImages[index].image = errorImage
                    self.itemImages[index].state = .failed
                }
                
                DispatchQueue.main.async {
                    let indexPath = IndexPath(item: index, section: section)
                    self.itemsCollectionView.reloadItems(at: [indexPath])
                }
            }
        default:
            break
        }
    }
}

//MARK: - Collection view delegate and data source methods

extension ItemListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sellItem", for: indexPath) as! SellItemCell
        
        if !items.isEmpty {
            let shopItem = items[indexPath.item]
            cell.itemPrice.text = "\(shopItem.price) ლ"
            cell.itemSize.text = shopItem.availableSizes.first
        
        
            let imageObject = itemImages[indexPath.item]
            
            if imageObject.state == .new || imageObject.state == .failed {
                getItemImage(at: indexPath.item)
            } else {
                cell.itemImage.image = imageObject.image
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        if !items.isEmpty {
            for indexPath in indexPaths {
                let imageObject = itemImages[indexPath.item]
                
                if imageObject.state == .new || imageObject.state == .failed {
                    getItemImage(at: indexPath.item)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let d: CGFloat = 20
        let heightToWidthRatio = 1.5
        let width = (itemsCollectionView.frame.width - d) / 2
        let height = width * CGFloat(heightToWidthRatio)
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedItem = items[indexPath.item]
        selectedImage = itemImages[indexPath.item].image
        
        performSegue(withIdentifier: "itemDetails", sender: self)
    }
}