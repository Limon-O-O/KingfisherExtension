//
//  UIButton+Kingfisher.swift
//  Example
//
//  Created by Limon on 7/6/16.
//  Copyright © 2016 KingfisherExtension. All rights reserved.
//

import Kingfisher

extension UIButton {

    public func kfe_setBackgroundImageWithURLString(URLString: String?,
                                   forState state: UIControlState,
                                            placeholderImage: UIImage? = nil,
                                            optionsInfo: KingfisherOptionsInfo? = nil,
                                            progressBlock: DownloadProgressBlock? = nil,
                                            completionHandler: Kingfisher.CompletionHandler? = nil) -> RetrieveImageTask?
    {
        return kfe_setImageWithURLString(URLString, forState: state, isSetingBackgroundImage: true, placeholderImage: placeholderImage, optionsInfo: optionsInfo, progressBlock: progressBlock, completionHandler: completionHandler)

    }

    public func kfe_setImageWithURLString(URLString: String?,
                                   forState state: UIControlState,
                                            placeholderImage: UIImage? = nil,
                                            optionsInfo: KingfisherOptionsInfo? = nil,
                                            progressBlock: DownloadProgressBlock? = nil,
                                            completionHandler: Kingfisher.CompletionHandler? = nil) -> RetrieveImageTask?
    {

        return kfe_setImageWithURLString(URLString, forState: state, isSetingBackgroundImage: false, placeholderImage: placeholderImage, optionsInfo: optionsInfo, progressBlock: progressBlock, completionHandler: completionHandler)

    }

    private func kfe_setImageWithURLString(URLString: String?,
                                   forState state: UIControlState,
                                   isSetingBackgroundImage: Bool,
                                   placeholderImage: UIImage? = nil,
                                   optionsInfo: KingfisherOptionsInfo? = nil,
                                   progressBlock: DownloadProgressBlock? = nil,
                                   completionHandler: Kingfisher.CompletionHandler? = nil) -> RetrieveImageTask?
    {

        guard let URLString = URLString, URL = NSURL(string: URLString) else {
            isSetingBackgroundImage ? setBackgroundImage(nil, forState: state) : setImage(nil, forState: state)
            return nil
        }

        guard let image = KingfisherManager.sharedManager.cache.retrieveImageInMemoryCacheForKey(URLString) ?? KingfisherManager.sharedManager.cache.retrieveImageInDiskCacheForKey(URLString) else {

            let optionInfoBuffer: KingfisherOptionsInfo = [
                .BackgroundDecode,
                .Transition(ImageTransition.Fade(0.35))
            ]

            return kf_setImageWithURL(URL,
                                      forState: state,
                                      placeholderImage: placeholderImage,
                                      optionsInfo: optionsInfo ?? optionInfoBuffer,
                                      progressBlock: progressBlock,
                                      completionHandler: completionHandler)
        }

        dispatch_async(dispatch_get_main_queue()) {
            UIView.performWithoutAnimation {
                isSetingBackgroundImage ? self.setBackgroundImage(image, forState: state) : self.setImage(image, forState: state)
            }
        }

        return nil
    }

}


// MARK: Image Resize

extension UIButton: ImageResizeable {

    public func kfe_setImage(byTransformer transformer: ImageReducible, forState state: UIControlState = .Normal, completionHandler: ((image: UIImage?) -> Void)? = nil) {
        kfe_setImage(byTransformer: transformer, forState: state, isSetingBackgroundImage: false, completionHandler: completionHandler)
    }

    public func kfe_setBackgroundImage(byTransformer transformer: ImageReducible, forState state: UIControlState = .Normal, completionHandler: ((image: UIImage?) -> Void)? = nil) {
        kfe_setImage(byTransformer: transformer, forState: state, isSetingBackgroundImage: true, completionHandler: completionHandler)
    }

    private func kfe_setImage(byTransformer transformer: ImageReducible, forState state: UIControlState = .Normal, isSetingBackgroundImage: Bool, completionHandler: ((image: UIImage?) -> Void)? = nil) {

        guard let URL = NSURL(string: transformer.URLString) else {
            isSetingBackgroundImage ? setBackgroundImage(nil, forState: state) : setImage(nil, forState: state)
            completionHandler?(image: nil)
            return
        }

        if let localStyledImage = transformer.localStyledImage {

            isSetingBackgroundImage ? setBackgroundImage(localStyledImage, forState: state) : setImage(localStyledImage, forState: state)
            completionHandler?(image: localStyledImage)

        } else if let localOriginalImage = transformer.localOriginalImage {

            resizeImage(byOriginalImage: localOriginalImage, transformer: transformer, action: { [weak self] reducedImage in

                guard let strongSelf = self else { return }
                isSetingBackgroundImage ? strongSelf.setBackgroundImage(reducedImage, forState: state) : strongSelf.setImage(reducedImage, forState: state)

            }, completionHandler: completionHandler)

        } else {

            setImage(transformer.placeholderImage, forState: state)

            KingfisherManager.sharedManager.downloader.downloadImageWithURL(URL, options: [.BackgroundDecode], progressBlock: nil) { [weak self] image, error, imageURL, originalData in

                guard let originalImage = image, strongSelf = self else { return }

                strongSelf.resizeImage(byOriginalImage: originalImage, transformer: transformer, action: { reducedImage in

                    isSetingBackgroundImage ? strongSelf.setBackgroundImage(reducedImage, forState: state) : strongSelf.setImage(reducedImage, forState: state)

                }, completionHandler: completionHandler)

                KingfisherManager.sharedManager.cache.storeImage(originalImage, originalData: originalData, forKey: URL.absoluteString, toDisk: true, completionHandler: nil)
            }
        }
    }
}
