//
//  SizeLabel.swift
//  SaZamtro
//
//  Created by Giorgi Shukakidze on 8/29/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

@IBDesignable class SizeLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 5
    @IBInspectable var bottomInset: CGFloat = 5
    @IBInspectable var leftInset: CGFloat = 5
    @IBInspectable var rightInset: CGFloat = 5
    @IBInspectable var borderWidth: CGFloat = 2
    @IBInspectable var borderColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(
            top: topInset,
            left: leftInset,
            bottom: bottomInset,
            right: rightInset
        )
        super.drawText(in: rect.inset(by: insets))
        layer.cornerRadius = 15
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        
        return CGSize(
            width: size.width + leftInset + rightInset,
            height: size.height + topInset + bottomInset
        )
    }

}
