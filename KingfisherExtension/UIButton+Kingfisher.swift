//
//  UIButton+Kingfisher.swift
//  KingfisherExtension
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

        guard let URLString = URLString, URL = NSURL(string: URLString) where !URLString.isEmpty else {
            print("[KingfisherExtension] \((#file as NSString).lastPathComponent)[\(#line)], \(#function): Image Downlaod error: URL Error")
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

extension UIButton {

    public func kfe_setImage(byTransformer transformer: ImageResizable, forState state: UIControlState = .Normal, toDisk: Bool = true, completionHandler: ((image: UIImage?) -> Void)? = nil) {

        kfe_setImage(byTransformer: transformer, action: { [weak self] image in

            self?.setImage(image, forState: state)

        }, toDisk: toDisk, completionHandler: completionHandler)
    }

    public func kfe_setBackgroundImage(byTransformer transformer: ImageResizable, forState state: UIControlState = .Normal, toDisk: Bool = true, completionHandler: ((image: UIImage?) -> Void)? = nil) {

        kfe_setImage(byTransformer: transformer, action: { [weak self] image in

            self?.setBackgroundImage(image, forState: state)

        }, toDisk: toDisk, completionHandler: completionHandler)
    }

}
