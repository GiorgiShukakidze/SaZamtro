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
    var downloadInProgress = false
    var moreItemsExist = true

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
    
    func getItems() {
        if downloadManager.isNetworkAvailable() {
            
            downloadInProgress = true
            
            downloadManager.fetchItems { [weak self] (items, error) in
                guard let self = self else { return }
                
                if error == nil {
                    self.items = items
                    if items.count == 0 { self.moreItemsExist = false }
                    
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
}
