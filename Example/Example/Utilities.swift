//
//  Utilities.swift
//  KingfisherExtension
//
//  Created by Limon on 6/24/16.
//  Copyright © 2016 KingfisherExtension. All rights reserved.
//

import UIKit

let ScreenBounds = UIScreen.main.bounds
let ScreenWidth = ceil(UIScreen.main.bounds.size.width)
let ScreenHeight = ceil(UIScreen.main.bounds.size.height)

extension UICollectionReusableView {
    static var kfe_className: String {
        return "\(self)"
    }
}
