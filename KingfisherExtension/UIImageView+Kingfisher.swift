//
//  UIImageView+Kingfisher.swift
//  KingfisherExtension
//
//  Created by Limon on 6/24/16.
//  Copyright © 2016 KingfisherExtension. All rights reserved.
//

import Kingfisher

extension UIImageView {

    public func kfe_setImageWithURLString(URLString: String?,
                                   placeholderImage: UIImage? = nil,
                                   optionsInfo: KingfisherOptionsInfo? = nil,
                                   progressBlock: DownloadProgressBlock? = nil,
                                   completionHandler: Kingfisher.CompletionHandler? = nil) -> RetrieveImageTask?
    {

        guard let URLString = URLString, URL = NSURL(string: URLString) where !URLString.isEmpty else {
            print("[KingfisherExtension] \((#file as NSString).lastPathComponent)[\(#line)], \(#function): Image Downlaod error: URL Error")
            image = nil
            return nil
        }

        guard let image = KingfisherManager.sharedManager.cache.retrieveImageInMemoryCacheForKey(URLString) ?? KingfisherManager.sharedManager.cache.retrieveImageInDiskCacheForKey(URLString) else {

            let optionInfoBuffer: KingfisherOptionsInfo = [
                .BackgroundDecode,
                .Transition(ImageTransition.Fade(0.35))
            ]

            return kf_setImageWithURL(URL,
                                      placeholderImage: placeholderImage,
                                      optionsInfo: optionsInfo ?? optionInfoBuffer,
                                      progressBlock: progressBlock,
                                      completionHandler: completionHandler)
        }

        dispatch_async(dispatch_get_main_queue()) {
            UIView.performWithoutAnimation {
                self.image = image
            }
        }

        return nil
    }

    public func kfe_setImage(byTransformer transformer: ImageResizable, toDisk: Bool = true, completionHandler: ((image: UIImage?) -> Void)? = nil) {

        kfe_setImage(byTransformer: transformer, action: { [weak self] image in

            self?.image = image

        }, toDisk: toDisk, completionHandler: completionHandler)
    }

}
