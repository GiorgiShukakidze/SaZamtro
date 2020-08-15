//
//  NothingToShowView.swift
//  SaZamtro
//
//  Created by Giorgi Shukakidze on 8/7/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class NothingToShowView: UIView {
    
    lazy var nothingToShowLabel: UILabel = {
      let label = UILabel()
        label.text = "Nothing to show..."
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }

    private func setupCell() {
        self.backgroundColor = .red
        self.alpha = 0.6
        self.addSubview(nothingToShowLabel)
        nothingToShowLabel.center = self.center
    }
    
}
