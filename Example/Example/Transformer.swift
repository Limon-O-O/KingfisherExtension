//
//  Transformer.swift
//  Example
//
//  Created by Limon on 6/24/16.
//  Copyright © 2016 KingfisherExtension. All rights reserved.
//

import UIKit
import KingfisherExtension

enum Style {
    static let square: ImageStyle = .Rectangle(size: CGSize(width: 60.0, height: 60.0))
    static let round1: ImageStyle = .RoundedRectangle(size: CGSize(width: 60.0, height: 60.0), cornerRadius: 8.0, borderWidth: 0)
    static let round2: ImageStyle = .RoundedRectangle(size: CGSize(width: 60.0, height: 60.0), cornerRadius: 16.0, borderWidth: 0)
    static let round3: ImageStyle = .RoundedRectangle(size: CGSize(width: 60.0, height: 60.0), cornerRadius: 60.0 * 0.5, borderWidth: 0)
}

struct Transformer {
    let URLString: String
    let style: ImageStyle
}

extension Transformer: ImageResizable {
    var placeholderImage: UIImage? {

        switch style {
        case .Original, .Rectangle:
            return DefaultImage.pixel
        case .RoundedRectangle:
            return DefaultImage.oval
        }
    }
}

struct DefaultImage {
    static let oval = UIImage(named: "default_avatar_oval")
    static let pixel = UIImage(named: "pixel")
}
