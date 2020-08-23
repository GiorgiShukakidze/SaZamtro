//
//  SaleView.swift
//  SaZamtro
//
//  Created by Giorgi Shukakidze on 8/20/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class SaleView: UIView {
    
    //MARK: - Sale ImageView
    lazy var saleImageview: UIImageView = {
        let aspectRatio: CGFloat = ViewConstants.banerAspectRatio
        let image = UIImage(named: ImageConstants.saleDefaultImage)
        
        let imageView = UIImageView(image: image)
        let width = UIScreen.main.bounds.width
        let height = width / aspectRatio
        self.frame.size = CGSize(width: width, height: height)
        self.frame.origin = CGPoint.zero
        imageView.frame = frame
        
        return imageView
    }()
    
    //MARK: - Shop Now Button
    lazy var shopNowButton: UIButton = {
        let button = UIButton(frame: CGRect.zero)
        button.setImage(UIImage(named: ImageConstants.shopNowImage), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitle(TextConstants.shopNow, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title3)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.40)
        button.layer.cornerRadius = ViewConstants.imageCornerRadius
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.frame.size = CGSize(
            width: button.intrinsicContentSize.width,
            height: button.intrinsicContentSize.height
        )
        button.frame.origin = CGPoint(
            x: self.frame.maxX - button.frame.width - ViewConstants.banerItemsSpacing,
            y: self.frame.maxY - button.frame.height - ViewConstants.banerItemsSpacing
        )
        
        return button
    }()
    
    //MARK: - Sale TextView
    lazy var saleTextView: UITextView = {
        let textView = UITextView()
        textView.text = TextConstants.saleDefaultText
        textView.textColor = .white
        textView.font = .preferredFont(forTextStyle: .title2)
        textView.frame.origin = CGPoint(x: self.frame.width / 2, y: ViewConstants.banerItemsSpacing)
        textView.frame.size.width = self.frame.width / 2 - ViewConstants.banerItemsSpacing
        textView.frame.size.height = shopNowButton.frame.origin.y - textView.frame.origin.y - ViewConstants.banerItemsSpacing
        textView.backgroundColor = .clear
        textView.layer.cornerRadius = ViewConstants.imageCornerRadius
        textView.layer.masksToBounds = true
        textView.isUserInteractionEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
        textView.textAlignment = .center
        textView.resizeText()
        
        return textView
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        
        self.clipsToBounds = true
        self.addSubview(saleImageview)
        self.addSubview(shopNowButton)
        self.addSubview(saleTextView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UITextView {
    func resizeText() {
        let textViewSize = self.frame.size;
        let fixedWidth = textViewSize.width;
        let expectSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)));

        var expectFont = self.font;
        if (expectSize.height > textViewSize.height) {
            while (self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height > textViewSize.height) {
                expectFont = self.font!.withSize(self.font!.pointSize - 1)
                self.font = expectFont
            }
        }
    }
}
