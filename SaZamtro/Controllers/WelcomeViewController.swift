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
    }
    
    func animateAppName(for titleText: String) {
        
        titleLabel.frame.size = CGSize.zero
        titleLabel.text = titleText
        titleLabel.alpha = 0
        
        UIView.animate(withDuration: 2, animations: {
            self.titleLabel.alpha = 1
            self.titleLabel.layoutIfNeeded()
        }) { (isTrue) in
            self.navigateToMainPage(after: 0.5)
        }
    }
    
    func navigateToMainPage(after seconds: Double) {
        Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { (timer) in
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
