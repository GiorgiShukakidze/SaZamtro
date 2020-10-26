//
//  DiscountLabel.swift
//  SaZamtro
//
//  Created by Giorgi Shukakidze on 8/28/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

@IBDesignable class DiscountLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 5
    @IBInspectable var bottomInset: CGFloat = 5
    @IBInspectable var leftInset: CGFloat = 10
    @IBInspectable var rightInset: CGFloat = 10
    @IBInspectable var borderWidth: CGFloat = 2
    @IBInspectable var borderColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(
            top: topInset,
            left: leftInset,
            bottom: bottomInset,
            right: rightInset
        )
        super.drawText(in: rect.inset(by: insets))
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
