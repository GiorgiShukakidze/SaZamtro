//
//  FirstViewController.swift
//  SaZamtro
//
//  Created by Giorgi Shukakidze on 5/24/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift

class ItemListViewController: UIViewController {
    
    var items = [Item]()
    var selectedItem: Item?
    var selectedImage: UIImage?
    var db = Firestore.firestore()
    var itemImages = [Int : UIImage]()

    let dispatchGroup = DispatchGroup()
    
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        
        fetchItems()
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let shopItem = selectedItem, let itemImage = selectedImage, segue.identifier == "itemDetails" {
            
            let destinationVC = segue.destination as! ItemDetailsViewController
            destinationVC.shopItem = shopItem
            destinationVC.shopItemImage = itemImage
        }
    }
    
    //MARK: - Fetch items from cloud firestore
    
    func fetchItems() {
        
        let collRef = db.collection(FBase.itemsCollection)
        
        collRef.getDocuments {[weak self] (querySnapshot, error) in
            guard let self = self else { return }

            if error == nil, let docs = querySnapshot?.documents {
                
                for doc in docs {
                    let result = Result {
                        try doc.data(as: Item.self)
                    }
                    
                    switch result {
                    case .success(let item):
                        if let item = item {
                            self.items.append(item)
                        } else {
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding item: \(error.localizedDescription)")
                    }
                }
                
                DispatchQueue.main.async { self.itemsCollectionView.reloadData() }
            } else {
                print("error: \(error?.localizedDescription ?? "Undefined error")")
            }
        }
    }
    
    //MARK: - Fetch image from firebase sorage
    
    func fetchImage(named imageName: String, completion: @escaping (UIImage) -> ()) {
        dispatchGroup.enter()

        let pathRef = Storage.storage().reference(forURL: FBase.imageUrl(named: imageName))
        pathRef.getData(maxSize: 2 * 1024 * 1024) { [weak self] (data, error) in
            guard let self = self else { return }

            if let fetchError = error {
                print("Error fetching image: \(fetchError.localizedDescription)")
            } else if let image = UIImage(data: data!) {
                completion(image)
            }

            self.dispatchGroup.leave()
        }
    }
}

extension ItemListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sellItem", for: indexPath) as! SellItemCell
        let shopItem = items[indexPath.item]
        cell.itemPrice.text = "\(shopItem.price) ლ"
        cell.itemSize.text = shopItem.availableSizes.first
        
        if let image = itemImages[indexPath.item] {
            cell.itemImage.image = image
        } else {
            fetchImage(named: shopItem.mainImage!) { (image) in
                cell.itemImage.image = image
                self.itemImages[indexPath.item] = image
            }
        }
            
        return cell
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
        selectedImage = itemImages[indexPath.item]
        performSegue(withIdentifier: "itemDetails", sender: self)
    }
}
