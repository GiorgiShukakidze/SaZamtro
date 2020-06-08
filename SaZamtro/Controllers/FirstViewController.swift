//
//  FirstViewController.swift
//  SaZamtro
//
//  Created by Giorgi Shukakidze on 5/24/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    var items = [UIImage]()
    var selectedImage: UIImage?
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for n in 1...10 {
           items.append(UIImage(named: "A\(n)")!)
        }
        
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
    }
}

extension FirstViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sellItem", for: indexPath) as! SellItemCell
        let sellItem = items[indexPath.item]
        cell.setUpCell(with: sellItem)
        
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
        selectedImage = items[indexPath.item]
        performSegue(withIdentifier: "itemDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewImage = selectedImage, segue.identifier == "itemDetails" {
            let destinationVC = segue.destination as! ItemDetailsViewController
            destinationVC.viewImage = viewImage
        }
    }
}
