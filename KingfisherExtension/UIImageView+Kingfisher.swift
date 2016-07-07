//
//  UIImageView+Kingfisher.swift
//  Example
//
//  Created by Limon on 6/24/16.
//  Copyright © 2016 KingfisherExtension. All rights reserved.
//

import Kingfisher

extension UIImageView: ImageResizeable {

    public func kfe_setImageWithURLString(URLString: String?,
                                   placeholderImage: UIImage? = nil,
                                   optionsInfo: KingfisherOptionsInfo? = nil,
                                   progressBlock: DownloadProgressBlock? = nil,
                                   completionHandler: Kingfisher.CompletionHandler? = nil) -> RetrieveImageTask?
    {

        guard let URLString = URLString, URL = NSURL(string: URLString) else {
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

    public func kfe_setImage(byTransformer transformer: ImageReducible, completionHandler: ((image: UIImage?) -> Void)? = nil) {

        guard let URL = NSURL(string: transformer.URLString) else {
            image = nil
            completionHandler?(image: nil)
            return
        }

        if let localStyledImage = transformer.localStyledImage {

            image = localStyledImage
            completionHandler?(image: localStyledImage)

        } else if let localOriginalImage = transformer.localOriginalImage {

            image = transformer.placeholderImage

            resizeImage(byOriginalImage: localOriginalImage, transformer: transformer, action: { [weak self] reducedImage in

                guard let strongSelf = self else { return }
                strongSelf.image = reducedImage

            }, completionHandler: completionHandler)

        } else {

            image = transformer.placeholderImage

            KingfisherManager.sharedManager.downloader.downloadImageWithURL(URL, options: [.BackgroundDecode], progressBlock: nil) { [weak self] image, error, imageURL, originalData in

                guard let originalImage = image, strongSelf = self else { return }

                strongSelf.resizeImage(byOriginalImage: originalImage, transformer: transformer, action: { reducedImage in

                    strongSelf.image = reducedImage

                }, completionHandler: completionHandler)

                KingfisherManager.sharedManager.cache.storeImage(originalImage, originalData: originalData, forKey: URL.absoluteString, toDisk: true, completionHandler: nil)
            }
        }
    }

}
