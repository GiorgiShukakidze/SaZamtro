//
//  Constants.swift
//  SaZamtro
//
//  Created by Giorgi Shukakidze on 6/17/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

struct FBase {
    static let itemsCollection = "items"
    static func imageUrl(named imageName: String) -> String {
        return "gs://sazamtro-98455.appspot.com/images/\(imageName).jpg"
    }
    static let limit = 8
}

struct ItemConstants {
    static let brandText = "ბრენდი"
    static let priceText = "ფასი"
    static let sizeText = "ზომა"
    static let shortCurrencyText = "₾"
    static let longCurrencyText = "ლარი"
    static let itemCellIdentifier = "sellItem"
}

struct ViewConstants {
    static let segueIdentifier = "itemDetails"
    static let headerToCollectionViewSpacing: CGFloat = 14
    static let imageCornerRadius: CGFloat = 20
    static let banerAspectRatio: CGFloat = 1.77
    static let banerItemsSpacing: CGFloat = 20
    static let cellHeightToWidthRatio: CGFloat = 1.1
    static let cellInsetSpacing: CGFloat = 20
    static let retryButtonTopSpacing: CGFloat = 10
    static let retryButtonSideSpacing: CGFloat = 25
    static let buttonCornerRadius: CGFloat = 20
    static let buttonBorderWidth: CGFloat = 2
}

struct ImageConstants {
    static let saleDefaultImage = "sale"
    static let shopNowImage = "arrow"
    static let retryImage = "connectionError"
    static let defaultImage = "notFoundImage"
}

struct TextConstants {
    static let errorPageText = "No Internet connection found. Check your connection or try again."
    static let errorTitleText = "Whoops!"
    static let shopNow = "  SHOP NOW"
    static let saleDefaultText = "Lorem Ipsum Dolorum 20%"
    static let retry = "TRY AGAIN"
    static let nothingToShowText = "Nothing to show...\nPlease retry."
}

struct ExternalLinks {
    static let fbAppLink = "fb://profile/103333864719745"
    static let fbWebLink = "https://www.facebook.com/Sazamtro-%E1%83%91%E1%83%90%E1%83%95%E1%83%A8%E1%83%95%E1%83%98%E1%83%A1-%E1%83%A2%E1%83%90%E1%83%9C%E1%83%A1%E1%83%90%E1%83%AA%E1%83%9B%E1%83%94%E1%83%9A%E1%83%98-103333864719745"
}

struct ConstraintConstants {
    static let retryButtonToViewBottomConstraint: CGFloat = -70
    static let errorTextLabelToTitleConstraint: CGFloat = 16
    static let errorTextLabelLeadingConstraint: CGFloat = 16
    static let errorTextLabelTrailingConstraint: CGFloat = -16
    static let errorImageViewLeadingConstraint: CGFloat = 40
    static let errorImageViewTrailingConstraint: CGFloat = -40
}

struct AppConstants {
    static let titleText = "SaZamtro"
}
