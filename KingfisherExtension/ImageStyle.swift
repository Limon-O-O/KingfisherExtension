//
//  ImageStyle.swift
//  KingfisherExtension
//
//  Created by Limon on 6/24/16.
//  Copyright © 2016 KingfisherExtension. All rights reserved.
//

import UIKit
import Kingfisher

public func ==(lhs: ImageStyle, rhs: ImageStyle) -> Bool {

    switch (lhs, rhs) {

    case (.Original, .Original):
        return true

    case (.Rectangle(let sizeA), .Rectangle(let sizeB)) where sizeA == sizeB:
        return true

    case (.RoundedRectangle(let sizeA, let cornerRadiusA, let borderWidthA), .RoundedRectangle(let sizeB, let cornerRadiusB, let borderWidthB)) where (sizeA == sizeB && cornerRadiusA == cornerRadiusB && borderWidthA == borderWidthB):
        return true

    default:
        return false
    }
}

public enum ImageStyle: Equatable {

    case Original
    case Rectangle(size: CGSize)
    case RoundedRectangle(size: CGSize, cornerRadius: CGFloat, borderWidth: CGFloat)

    var hashString: String {

        switch self {

        case .Original:
            return "Original-"

        case .Rectangle(let size):
            return "Rectangle-\(size)-"

        case .RoundedRectangle(let size, let cornerRadius, let borderWidth):
            return "RoundedRectangle-\(size)-\(cornerRadius)-\(borderWidth)-"
        }
    }
}

public protocol ImageResizable {

    var URLString: String { get }
    var style: ImageStyle { get }
    var placeholderImage: UIImage? { get }
}

extension ImageResizable {

    public var key: String {
        return style.hashString + URLString
    }

    public var originalImageKey: String {
        return URLString
    }

    public var localStyledImage: UIImage? {
        return KingfisherManager.sharedManager.cache.retrieveImageInMemoryCacheForKey(key) ?? KingfisherManager.sharedManager.cache.retrieveImageInDiskCacheForKey(key, scale: UIScreen.mainScreen().scale)
    }

    public var localOriginalImage: UIImage? {
        return KingfisherManager.sharedManager.cache.retrieveImageInMemoryCacheForKey(originalImageKey) ?? KingfisherManager.sharedManager.cache.retrieveImageInDiskCacheForKey(originalImageKey, scale: UIScreen.mainScreen().scale)
    }

    public var placeholderImage: UIImage? {
        return nil
    }

    public func removeImage() {

        guard !originalImageKey.isEmpty else { return }

        KingfisherManager.sharedManager.cache.removeImageForKey(originalImageKey)
        KingfisherManager.sharedManager.cache.removeImageForKey(key)
    }
}

