//
//  UIButton+Kingfisher.swift
//  KingfisherExtension
//
//  Created by Limon on 7/6/16.
//  Copyright © 2016 KingfisherExtension. All rights reserved.
//

import Kingfisher

extension UIButton {

    public func kfe_setBackgroundImageWithURLString(_ URLString: String?,
                                   forState state: UIControlState,
                                            placeholderImage: UIImage? = nil,
                                            optionsInfo: KingfisherOptionsInfo? = nil,
                                            progressBlock: DownloadProgressBlock? = nil,
                                            completionHandler: CompletionHandler? = nil) -> RetrieveImageTask?
    {
        return kfe_setImageWithURLString(URLString, forState: state, isSetingBackgroundImage: true, placeholderImage: placeholderImage, optionsInfo: optionsInfo, progressBlock: progressBlock, completionHandler: completionHandler)

    }

    public func kfe_setImageWithURLString(_ URLString: String?,
                                   forState state: UIControlState,
                                            placeholderImage: UIImage? = nil,
                                            optionsInfo: KingfisherOptionsInfo? = nil,
                                            progressBlock: DownloadProgressBlock? = nil,
                                            completionHandler: CompletionHandler? = nil) -> RetrieveImageTask?
    {

        return kfe_setImageWithURLString(URLString, forState: state, isSetingBackgroundImage: false, placeholderImage: placeholderImage, optionsInfo: optionsInfo, progressBlock: progressBlock, completionHandler: completionHandler)

    }

    private func kfe_setImageWithURLString(_ URLString: String?,
                                   forState state: UIControlState,
                                   isSetingBackgroundImage: Bool,
                                   placeholderImage: UIImage? = nil,
                                   optionsInfo: KingfisherOptionsInfo? = nil,
                                   progressBlock: DownloadProgressBlock? = nil,
                                   completionHandler: CompletionHandler? = nil) -> RetrieveImageTask?
    {

        guard let URLString = URLString, let URL = URL(string: URLString), !URLString.isEmpty else {
            print("[KingfisherExtension] \((#file as NSString).lastPathComponent)[\(#line)], \(#function): Image Downlaod error: URL Error")
            isSetingBackgroundImage ? setBackgroundImage(nil, for: state) : setImage(nil, for: state)
            return nil
        }

        guard let image = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: URLString) ?? KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: URLString) else {

            let optionInfoBuffer: KingfisherOptionsInfo = [
                .backgroundDecode,
                .transition(ImageTransition.fade(0.35))
            ]

            return kf.setImage(with: URL,
                               for: state,
                               placeholder: placeholderImage,
                               options: optionsInfo ?? optionInfoBuffer,
                               progressBlock: progressBlock,
                               completionHandler: completionHandler)
        }

        DispatchQueue.main.async {
            UIView.performWithoutAnimation {
                isSetingBackgroundImage ? self.setBackgroundImage(image, for: state) : self.setImage(image, for: state)
            }
        }

        return nil
    }

}

extension UIButton {

    public func kfe_setImage(byTransformer transformer: ImageResizable, forState state: UIControlState = UIControlState(), toDisk: Bool = true, completionHandler: ((_ image: UIImage?) -> Void)? = nil) {

        kfe_setImage(byTransformer: transformer, action: { [weak self] image in

            self?.setImage(image, for: state)

        }, toDisk: toDisk, completionHandler: completionHandler)
    }

    public func kfe_setBackgroundImage(byTransformer transformer: ImageResizable, forState state: UIControlState = UIControlState(), toDisk: Bool = true, completionHandler: ((_ image: UIImage?) -> Void)? = nil) {

        kfe_setImage(byTransformer: transformer, action: { [weak self] image in

            self?.setBackgroundImage(image, for: state)

        }, toDisk: toDisk, completionHandler: completionHandler)
    }

}
