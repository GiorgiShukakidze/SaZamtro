//
//  WelcomeViewController.swift
//  SaZamtro
//
//  Created by Giorgi Shukakidze on 8/3/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animateAppName(for: AppConstants.titleText)
        navigateToMainPage(after: AppConstants.titleText)
    }
    
    func animateAppName(for titleText: String) {
        var charCount = 0.0
        
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.15 * charCount, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
        charCount += 1
        }
    }
    
    func navigateToMainPage(after titleText: String) {
        Timer.scheduledTimer(withTimeInterval: 0.15 * Double((titleText.count + 1)), repeats: false) { (timer) in
            Auth.auth().signInAnonymously { (result, error) in
                if error != nil {
                    print(error!.localizedDescription)
                }
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController")
                UIApplication.shared.windows.first?.rootViewController = vc
            }
        }
    }
    
    
}
