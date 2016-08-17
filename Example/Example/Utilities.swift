//
//  Utilities.swift
//  KingfisherExtension
//
//  Created by Limon on 6/24/16.
//  Copyright © 2016 KingfisherExtension. All rights reserved.
//

import UIKit

let ScreenBounds = UIScreen.mainScreen().bounds
let ScreenWidth = ceil(UIScreen.mainScreen().bounds.size.width)
let ScreenHeight = ceil(UIScreen.mainScreen().bounds.size.height)

extension UICollectionReusableView {
    static var kfe_className: String {
        return "\(self)"
    }
}
