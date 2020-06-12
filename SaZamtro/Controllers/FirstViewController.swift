//
//  FirstViewController.swift
//  SaZamtro
//
//  Created by Giorgi Shukakidze on 5/24/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    var items = [Item]()
    var selectedItem: Item?
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for n in 1...10 {
           items.append(Item(images: ["A\(n)"],
                             availableSizes: ["3M"],
                             price: 200,
                             description: "ბლა ბლა ბლა  jhadas akld askj dadksj kjasd kajs kajs dkjas dkjas jka dkjas kja dkj as kjdsadjk sajk kjas dkaj dkjaj djkaskjad kj kj  kj kj jk kj kj kj ბლა ბ ლა ბლა ბლა ბლა ბლა ბლა ბლა ბლს ბლსდაჰჯბაჯჰდს კჯგ დადსგჰჯ დსაგ  \(n)",
                             title: "ბავშვის ზედა \(n)",
                             brand: "Carters"))
        }
        
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let shopItem = selectedItem, segue.identifier == "itemDetails" {
            let destinationVC = segue.destination as! ItemDetailsViewController
            destinationVC.shopItem = shopItem
        }
    }
}

extension FirstViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sellItem", for: indexPath) as! SellItemCell
        let shopItem = items[indexPath.item]
        cell.setUpCell(with: shopItem)

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
        performSegue(withIdentifier: "itemDetails", sender: self)
    }
}
