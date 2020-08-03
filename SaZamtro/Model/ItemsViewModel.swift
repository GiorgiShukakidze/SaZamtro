//
//  ItemViewModel.swift
//  SaZamtro
//
//  Created by Giorgi Shukakidze on 6/29/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import Foundation

protocol ItemsViewModelDelegate {
    func itemsFetchDidCompleteWithResult()
    func itemsFetchDidCompleteWithError()
    func didFinishFetchingImage(at index: Int)
}

class ItemsViewModel {
    private var items = [Item]()
    private lazy var downloadManager = DownloadManager.shared
    var delegate: ItemsViewModelDelegate?
    lazy var downloadInProgress = false
    lazy var moreItemsAvailable = true

    func item(at index: Int) -> Item {
        return items[index]
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    //MARK: - Get items
    
    func getItems(currentItem: Item? = nil) {
        if downloadManager.isNetworkAvailable() {
            
            if !shouldLoadMore(currentItem: currentItem) {
                return
            }
            
            downloadInProgress = true
            
            downloadManager.fetchItemDetails { [weak self] (itemsDetails, error) in
                guard let self = self else { return }
                
                if error == nil {
                    if itemsDetails.count < FBase.limit { self.moreItemsAvailable = false }
                    
                    for itemDetails in itemsDetails {
                        
                        if let imageUrl = itemDetails.mainImage {
                            
                            let item = Item(itemDetails: itemDetails,
                                            itemImage: ItemImage(name: itemDetails.title,
                                                                 url: imageUrl))
                            
                            self.items.append(item)
                            self.getItemImage(at: (self.items.count - 1))
                        }
                    }
                    
                    self.delegate?.itemsFetchDidCompleteWithResult()
                    
                } else {
                    print(error!.localizedDescription)
                    self.delegate?.itemsFetchDidCompleteWithError()
                }
                
                self.downloadInProgress = false
            }
        } else {
            self.delegate?.itemsFetchDidCompleteWithError()
        }
    }
    
    //MARK: - Get Item images
    
    func getItemImage(at index: Int) {
        let itemImage = items[index].itemImage
        
        switch itemImage.state {
        case .failed, .new:
            items[index].itemImage.state = .pending
            
            downloadManager.fetchImage(named: itemImage.url) { [weak self] (image, error) in
                guard let self = self else { return }
                
                if error == nil {
                    self.items[index].itemImage.setImage(image)
                    self.items[index].itemImage.state = .downloaded
                } else {
                    self.items[index].itemImage.setImage()
                    self.items[index].itemImage.state = .failed
                }

                self.delegate?.didFinishFetchingImage(at: index)
            }
        default:
            break
        }
    }
    
    //MARK: - Utilities
    
    private func shouldLoadMore(currentItem: Item? = nil) -> Bool {
        if downloadInProgress || !moreItemsAvailable {
            return false
        }
        
        guard let currentItem = currentItem else {
            return true
        }
        
        guard let lastItem = items.last else {
            return true
        }
        
        return currentItem == lastItem
    }
}
