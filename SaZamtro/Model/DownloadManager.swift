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
import Network

class DownloadManager {
    
    static let shared = DownloadManager()
    
    private let db = Firestore.firestore()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "com.gshukakidze.SaZamtro.Monitor")
    private lazy var networkAvailable = true
    private var lastDocument: QueryDocumentSnapshot?
    
    
    func isNetworkAvailable() -> Bool {
        return networkAvailable
    }
    
    func fetchItemDetails(completion: @escaping ([ItemDetails], Error?) -> ()) {
        var items = [ItemDetails]()
        let query: Query
        
        if let lastDocument = lastDocument {
            query = db.collection(FBase.itemsCollection)
                .limit(to: FBase.limit)
                .start(afterDocument: lastDocument)
        } else {
            query = db.collection(FBase.itemsCollection)
                .limit(to: FBase.limit)
        }
        
        query.getDocuments { (querySnapshot, error) in
            if error == nil, let docs = querySnapshot?.documents {
                
                if let lastDoc = docs.last {
                    self.lastDocument = lastDoc
                }
                
                for doc in docs {
                    let result = Result {
                        try doc.data(as: ItemDetails.self)
                    }
                    
                    switch result {
                    case .success(let item):
                        if var item = item {
                            item.id = UUID()
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
            }
        }
    }
    
    func monitorNetwork() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.networkAvailable = true
            } else {
                self.networkAvailable = false
            }
        }
        
        monitor.start(queue: queue)
    }
}

