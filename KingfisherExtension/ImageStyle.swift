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

    case (.original, .original):
        return true

    case (.rectangle(let sizeA), .rectangle(let sizeB)) where sizeA == sizeB:
        return true

    case (.roundedRectangle(let sizeA, let cornerRadiusA, let borderWidthA), .roundedRectangle(let sizeB, let cornerRadiusB, let borderWidthB)) where (sizeA == sizeB && cornerRadiusA == cornerRadiusB && borderWidthA == borderWidthB):
        return true

    default:
        return false
    }
}

public enum ImageStyle: Equatable {

    case original
    case rectangle(size: CGSize)
    case roundedRectangle(size: CGSize, cornerRadius: CGFloat, borderWidth: CGFloat)

    var hashString: String {

        switch self {

        case .original:
            return "Original-"

        case .rectangle(let size):
            return "Rectangle-\(size)-"

        case .roundedRectangle(let size, let cornerRadius, let borderWidth):
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
        return KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: key) ?? KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: key, options: [.backgroundDecode])
    }

    public var localOriginalImage: UIImage? {
        return KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: originalImageKey) ?? KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: originalImageKey)
    }

    public var placeholderImage: UIImage? {
        return nil
    }

    public func removeImage() {

        guard !originalImageKey.isEmpty else { return }

        KingfisherManager.shared.cache.removeImage(forKey: originalImageKey)
        KingfisherManager.shared.cache.removeImage(forKey: key)
    }
}

