//
//  UIView+Kingfisher.swift
//  KingfisherExtension
//
//  Created by Limon on 7/7/16.
//  Copyright © 2016 KingfisherExtension. All rights reserved.
//

import Kingfisher

extension UIView {

    private func kfe_resizeImage(byOriginalImage originalImage: UIImage, transformer: ImageResizable, action: (reducedImage: UIImage) -> Void, toDisk: Bool, completionHandler: ((image: UIImage?) -> Void)?) {

        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {

            let reducedImage = originalImage.navi_avatarImageWithStyle(transformer.style)

            let showImage = {

                UIView.transitionWithView(self, duration: 0.3, options: .TransitionCrossDissolve, animations: {

                    action(reducedImage: reducedImage)

                }, completion: { _ in

                    completionHandler?(image: reducedImage)
                })
            }

            KingfisherManager.sharedManager.cache.storeImage(reducedImage, originalData: nil, forKey: transformer.key, toDisk: toDisk, completionHandler: {
                showImage()
            })
        }
    }

    func kfe_setImage(byTransformer transformer: ImageResizable, action: (image: UIImage?) -> Void, toDisk: Bool, completionHandler: ((image: UIImage?) -> Void)?) {

        guard !transformer.URLString.isEmpty, let URL = NSURL(string: transformer.URLString) else {

            print("[KingfisherExtension] \((#file as NSString).lastPathComponent)[\(#line)], \(#function): Image Downlaod error: URL Error")

            action(image: nil)
            completionHandler?(image: nil)
            return
        }

        if let localStyledImage = transformer.localStyledImage {

            action(image: localStyledImage)
            completionHandler?(image: localStyledImage)

        } else if let localOriginalImage = transformer.localOriginalImage {

            kfe_resizeImage(byOriginalImage: localOriginalImage, transformer: transformer, action: { reducedImage in

                action(image: reducedImage)

            }, toDisk: toDisk, completionHandler: completionHandler)

        } else {

            action(image: transformer.placeholderImage)

            KingfisherManager.sharedManager.downloader.downloadImageWithURL(URL, options: [.BackgroundDecode], progressBlock: nil) { [weak self] image, error, imageURL, originalData in

                guard let originalImage = image, strongSelf = self else { return }

                strongSelf.kfe_resizeImage(byOriginalImage: originalImage, transformer: transformer, action: { reducedImage in

                    action(image: reducedImage)

                }, toDisk: toDisk, completionHandler: completionHandler)

                if toDisk {
                    KingfisherManager.sharedManager.cache.storeImage(originalImage, originalData: originalData, forKey: URL.absoluteString, toDisk: true, completionHandler: nil)
                }
            }
        }
    }
}

