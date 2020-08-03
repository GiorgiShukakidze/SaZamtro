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
    private var itemImages = [ItemImage]()
    var delegate: ItemsViewModelDelegate?
    lazy var downloadInProgress = false
    lazy var moreItemsAvailable = true

    func item(at index: Int) -> Item {
        return items[index]
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func itemImage(at index: Int) -> ItemImage {
        return itemImages[index]
    }
    
    func addItemImageObject(_ image: ItemImage) {
        itemImages.append(image)
    }
    
    //MARK: - Get items
    
    func getItems(currentItem: Item? = nil) {
        if downloadManager.isNetworkAvailable() {
            
            if !shouldLoadMore(currentItem: currentItem) {
                return
            }
            
            downloadInProgress = true
            
            downloadManager.fetchItems { [weak self] (items, error) in
                guard let self = self else { return }
                
                if error == nil {
                    if items.count < FBase.limit { self.moreItemsAvailable = false }
                    
                    self.items.append(contentsOf: items)
                    
                    for item in items {
                        if let index = self.items.firstIndex(of: item), let imageUrl = item.mainImage {
                            let imageObject = ItemImage(name: item.title, url: imageUrl)
                            self.addItemImageObject(imageObject)
                            self.getItemImage(at: index)
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
        let imageObject = itemImages[index]
        
        switch imageObject.state {
        case .failed, .new:
            itemImages[index].state = .pending
            
            downloadManager.fetchImage(named: imageObject.url) { [weak self] (image, error) in
                guard let self = self else { return }
                
                if error == nil {
                    self.itemImages[index].setImage(image)
                    self.itemImages[index].state = .downloaded
                } else {
                    self.itemImages[index].setImage()
                    self.itemImages[index].state = .failed
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
        return currentItem.id == lastItem.id
    }
}
