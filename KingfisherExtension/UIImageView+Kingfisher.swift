//
//  UIImageView+Kingfisher.swift
//  KingfisherExtension
//
//  Created by Limon on 6/24/16.
//  Copyright © 2016 KingfisherExtension. All rights reserved.
//

import Kingfisher

extension UIImageView {

    public func kfe_setImageWithURLString(_ URLString: String?,
                                   placeholderImage: UIImage? = nil,
                                   optionsInfo: KingfisherOptionsInfo? = nil,
                                   progressBlock: DownloadProgressBlock? = nil,
                                   completionHandler: CompletionHandler? = nil) -> RetrieveImageTask?
    {

        guard let URLString = URLString, let URL = URL(string: URLString), !URLString.isEmpty else {
            print("[KingfisherExtension] \((#file as NSString).lastPathComponent)[\(#line)], \(#function): Image Downlaod error: URL Error")
            image = nil
            return nil
        }

        guard let image = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: URLString) ?? KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: URLString) else {

            let optionInfoBuffer: KingfisherOptionsInfo = [
                .backgroundDecode,
                .transition(ImageTransition.fade(0.35))
            ]

            return kf.setImage(with: URL,
                               placeholder: placeholderImage,
                               options: optionsInfo ?? optionInfoBuffer,
                               progressBlock: progressBlock,
                               completionHandler: completionHandler)
        }

        DispatchQueue.main.async {
            UIView.performWithoutAnimation {
                self.image = image
            }
        }

        return nil
    }

    public func kfe_setImage(byTransformer transformer: ImageResizable, toDisk: Bool = true, completionHandler: ((_ image: UIImage?) -> Void)? = nil) {

        kfe_setImage(byTransformer: transformer, action: { [weak self] image in

            self?.image = image

        }, toDisk: toDisk, completionHandler: completionHandler)
    }

}
