//
//  ConnectionErrorView.swift
//  SaZamtro
//
//  Created by Giorgi Shukakidze on 8/15/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class ConnectionErrorView: UIStackView {
    
    let button = UIButton(type: .custom)
    let label = UILabel(frame: CGRect.zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupStackView() {
        setupButton()
        setupLabel()
        
        self.addArrangedSubview(label)
        self.addArrangedSubview(button)
        self.alignment = .center
        self.distribution = .fill
        self.axis = .vertical
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupButton() {
        button.setTitle("Retry ", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.4039215686, green: 0.6078431373, blue: 0.6078431373, alpha: 1), for: .normal)
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.4039215686, green: 0.6078431373, blue: 0.6078431373, alpha: 1)
        
        let buttonWidth = button.frame.width
        let imageWidth = button.imageView!.frame.width
        let spacing: CGFloat = 8.0
        button.imageEdgeInsets = UIEdgeInsets(
            top: 0,
            left: buttonWidth - imageWidth,
            bottom: 0,
            right: -(buttonWidth - imageWidth + spacing)
        )
        button.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -buttonWidth + spacing,
            bottom: 0,
            right: imageWidth - spacing
        )
        button.contentEdgeInsets = UIEdgeInsets(
            top: 0,
            left: spacing,
            bottom: 0,
            right: spacing
        )
    }

    private func setupLabel() {
        label.text = "Connection Error."
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
    }
}
