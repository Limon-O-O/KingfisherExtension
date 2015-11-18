//
//  UIImageView+Extension.swift
//  Example
//
//  Created by catch on 15/11/17.
//  Copyright © 2015年 KingfisherExtension. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {

    func kfe_setImageWithURLString(URLString: String?) -> RetrieveImageTask? {
        return kfe_setImageWithURLString(URLString,
            placeholderImage: nil,
            optionsInfo: nil,
            progressBlock: nil,
            completionHandler: nil)
    }

    func kfe_setRoundImageWithURLString(URLString: String?, cornerRadius: CGFloat? = nil, options: KingfisherManager.Options = KingfisherManager.DefaultOptions, progressBlock: ImageDownloaderProgressBlock? = nil) {

        guard let URLString = URLString, URL = NSURL(string: URLString) else {
            return
        }

        guard let image = KingfisherManager.sharedManager.cache.retrieveImageInMemoryCacheForKey(URLString) ?? KingfisherManager.sharedManager.cache.retrieveImageInDiskCacheForKey(URLString) else {

            KingfisherManager.sharedManager.downloader.downloadImageWithURL(URL, options: options, progressBlock: progressBlock) { (image, error, imageURL, originalData) -> () in

                if let image = image, originalData = originalData {

                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {

                        let roundedImage = image.kfe_roundWithCornerRadius(cornerRadius ?? image.size.width/2)

                        KingfisherManager.sharedManager.cache.storeImage(roundedImage, originalData: originalData, forKey: URLString, toDisk: true, completionHandler: {
                            self.kfe_setImageWithURLString(URLString)
                        })
                    }
                }
            }

            return
        }

        self.image = image
    }

    func kfe_setImageWithURLString(URLString: String?,
        placeholderImage: UIImage?) -> RetrieveImageTask?
    {
        return kfe_setImageWithURLString(URLString,
            placeholderImage: placeholderImage,
            optionsInfo: nil,
            progressBlock: nil,
            completionHandler: nil)
    }

    func kfe_setImageWithURLString(URLString: String?,
        placeholderImage: UIImage?,
        optionsInfos: KingfisherOptionsInfo?) -> RetrieveImageTask?
    {

        return kfe_setImageWithURLString(URLString,
            placeholderImage: placeholderImage,
            optionsInfo: optionsInfos,
            progressBlock: nil,
            completionHandler: nil)
    }

    func kfe_setImageWithURLString(URLString: String?,
        placeholderImage: UIImage?,
        optionsInfo: KingfisherOptionsInfo?,
        completionHandler: CompletionHandler?) -> RetrieveImageTask?
    {
        return kfe_setImageWithURLString(URLString,
            placeholderImage: placeholderImage,
            optionsInfo: optionsInfo,
            progressBlock: nil,
            completionHandler: completionHandler)
    }

    func kfe_setImageWithURLString(URLString: String?,
        placeholderImage: UIImage?,
        optionsInfo: KingfisherOptionsInfo?,
        progressBlock: DownloadProgressBlock?,
        completionHandler: CompletionHandler?) -> RetrieveImageTask?
    {

        guard let URLString = URLString, URL = NSURL(string: URLString) ?? URLEncoded(string: URLString) else {
            print(" URL Error")
            return nil
        }

        guard let image = KingfisherManager.sharedManager.cache.retrieveImageInMemoryCacheForKey(URLString) ?? KingfisherManager.sharedManager.cache.retrieveImageInDiskCacheForKey(URLString) else {

            let defaultOptions: KingfisherOptionsInfo = [
                .Options([.BackgroundDecode, .LowPriority]),
                .Transition(ImageTransition.Fade(0.55))
            ]

            return kf_setImageWithURL(URL,
                placeholderImage: placeholderImage,
                optionsInfo: optionsInfo ?? defaultOptions,
                progressBlock: progressBlock,
                completionHandler: completionHandler)
        }

        self.image = image

        return nil
    }

    private func URLEncoded(string URLString: String) -> NSURL? {
        guard let URLEncodingString = URLString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) else {
            return nil
        }
        return NSURL(string: URLEncodingString)
    }

}

extension UIImage {

    func kfe_roundWithCornerRadius(cornerRadius: CGFloat) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        drawInRect(rect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}
