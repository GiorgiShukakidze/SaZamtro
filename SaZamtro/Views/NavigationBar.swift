//
//  NavigationBar.swift
//  SaZamtro
//
//  Created by Giorgi Shukakidze on 8/28/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

@IBDesignable class NavigationBar: UINavigationBar {
    
    @IBOutlet weak var logoStackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupBar()
    }
    
    private func setupBar() {
        let bundle = Bundle(for: NavigationBar.self)
        bundle.loadNibNamed("NavigationBar", owner: self, options: nil)
        logoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(logoStackView)
        
        isTranslucent = false
        backgroundColor = .clear
        shadowImage = UIImage()
    }
}
