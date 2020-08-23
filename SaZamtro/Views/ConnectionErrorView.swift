//
//  ConnectionErrorView.swift
//  SaZamtro
//
//  Created by Giorgi Shukakidze on 8/15/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class ConnectionErrorView: UIView {
    
    lazy var retryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(TextConstants.retry, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = ViewConstants.buttonCornerRadius
        button.layer.borderWidth = ViewConstants.buttonBorderWidth
        button.layer.borderColor = UIColor.black.cgColor
        button.contentEdgeInsets = UIEdgeInsets(
            top: ViewConstants.retryButtonTopSpacing,
            left: ViewConstants.retryButtonSideSpacing,
            bottom: ViewConstants.retryButtonTopSpacing,
            right: ViewConstants.retryButtonSideSpacing
        )
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.text = TextConstants.errorTitleText
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var textLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.text = TextConstants.errorPageText
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var errorImageView: UIImageView = {
        let errorImage = UIImage(named: ImageConstants.retryImage)
        let imageView = UIImageView(image: errorImage)
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleLabel)
        self.addSubview(errorImageView)
        self.addSubview(textLabel)
        self.addSubview(retryButton)
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupConstraints() {
        retryButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        retryButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: ConstraintConstants.retryButtonToViewBottomConstraint).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ConstraintConstants.errorTextLabelToTitleConstraint).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: ConstraintConstants.errorTextLabelLeadingConstraint).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: ConstraintConstants.errorTextLabelTrailingConstraint).isActive = true
        errorImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        errorImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
        errorImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: ConstraintConstants.errorImageViewLeadingConstraint).isActive = true
        errorImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: ConstraintConstants.errorImageViewTrailingConstraint).isActive = true
        errorImageView.addConstraint(NSLayoutConstraint(item: errorImageView,
                                                        attribute: NSLayoutConstraint.Attribute.height,
                                                        relatedBy: NSLayoutConstraint.Relation.equal,
                                                        toItem: errorImageView,
                                                        attribute: NSLayoutConstraint.Attribute.width,
                                                        multiplier: errorImageView.frame.size.height / errorImageView.frame.size.width,
                                                        constant: 0))
    }
}
