//
//  UIImageView+Kingfisher.swift
//  Example
//
//  Created by Limon on 6/24/16.
//  Copyright © 2016 KingfisherExtension. All rights reserved.
//

import Kingfisher

public extension UIImageView {

    func kfe_setImageWithURLString(URLString: String?) -> RetrieveImageTask? {
        return kfe_setImageWithURLString(URLString,
                                         placeholderImage: nil,
                                         optionsInfo: nil,
                                         progressBlock: nil,
                                         completionHandler: nil)
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
                                   completionHandler: Kingfisher.CompletionHandler?) -> RetrieveImageTask?
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
                                   completionHandler: Kingfisher.CompletionHandler?) -> RetrieveImageTask?
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

    func kfe_setImage(byTransformer transformer: ImageReducible, completionHandler: ((image: UIImage?) -> Void)? = nil) {

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
            showImage(localOriginalImage, transformer: transformer, completionHandler: completionHandler)

        } else {

            image = transformer.placeholderImage

            KingfisherManager.sharedManager.downloader.downloadImageWithURL(URL, options: [.BackgroundDecode], progressBlock: nil) { [weak self] image, error, imageURL, originalData in

                guard let originalImage = image else { return }

                self?.showImage(originalImage, transformer: transformer, completionHandler: completionHandler)

                KingfisherManager.sharedManager.cache.storeImage(originalImage, originalData: originalData, forKey: URL.absoluteString, toDisk: true, completionHandler: nil)
            }
        }
    }

    private func showImage(originalImage: UIImage, transformer: ImageReducible, completionHandler: ((image: UIImage?) -> Void)?) {

        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {

            let reducedImage = originalImage.navi_avatarImageWithStyle(transformer.style)

            KingfisherManager.sharedManager.cache.storeImage(reducedImage, originalData: nil, forKey: transformer.key, toDisk: true, completionHandler: {

                dispatch_async(dispatch_get_main_queue()) {

                    UIView.transitionWithView(self, duration: 0.3, options: .TransitionCrossDissolve, animations: {
                        self.image = reducedImage

                    }, completion: { _ in
                        completionHandler?(image: reducedImage)
                    })
                }

            })
        }

    }

}
