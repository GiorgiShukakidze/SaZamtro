//
//  PhotoOperations.swift
//  SaZamtro
//
//  Created by Giorgi Shukakidze on 6/24/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift

class DownloadManager {
    
    let db = Firestore.firestore()
    lazy var query = db.collection(FBase.itemsCollection)
    
    func fetchItems(completion: @escaping ([Item], Error?) -> ()) {
        var items = [Item]()
        
        query.getDocuments { (querySnapshot, error) in
            if error == nil, let docs = querySnapshot?.documents {
                
                //                if let lastDoc = docs.last {
                //                    self.lastDocument = lastDoc
                //                }
                
                for doc in docs {
                    let result = Result {
                        try doc.data(as: Item.self)
                    }
                    
                    switch result {
                    case .success(let item):
                        if let item = item {
                            items.append(item)
                        } else {
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding item: \(error.localizedDescription)")
                    }
                }
                completion(items, nil)
                
            } else {
                completion(items, error)
                print("error: \(error?.localizedDescription ?? "Undefined error")")
            }
        }
    }
    
    func fetchImage(named imageName: String, completion: @escaping (UIImage?, Error?) -> ()) {
        
        let pathRef = Storage.storage().reference(forURL: FBase.imageUrl(named: imageName))
        pathRef.getData(maxSize: 2 * 1024 * 1024) { (data, error) in
            
            if let fetchError = error {
                completion(nil, error)
                print("Error fetching image: \(fetchError.localizedDescription)")
            } else if let image = UIImage(data: data!) {
                completion(image, nil)
                print("Images Fetched")
            }
        }
    }
}

