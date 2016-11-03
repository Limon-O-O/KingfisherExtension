//
//  UIView+Kingfisher.swift
//  KingfisherExtension
//
//  Created by Limon on 7/7/16.
//  Copyright © 2016 KingfisherExtension. All rights reserved.
//

import Kingfisher

extension UIView {

    private func kfe_resizeImage(byOriginalImage originalImage: UIImage, transformer: ImageResizable, action: @escaping (_ reducedImage: UIImage) -> Void, toDisk: Bool, completionHandler: ((_ image: UIImage?) -> Void)?) {

        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {

            let reducedImage = originalImage.navi_avatarImageWithStyle(transformer.style)

            let showImage = {

                UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {

                    action(reducedImage)

                }, completion: { _ in

                    completionHandler?(reducedImage)
                })
            }

            KingfisherManager.shared.cache.store(reducedImage, original: nil, forKey: transformer.key, toDisk: toDisk, completionHandler: {
                showImage()
            })
        }
    }

    func kfe_setImage(byTransformer transformer: ImageResizable, action: @escaping (_ image: UIImage?) -> Void, toDisk: Bool, completionHandler: ((_ image: UIImage?) -> Void)?) {

        guard !transformer.URLString.isEmpty, let URL = URL(string: transformer.URLString) else {

            print("[KingfisherExtension] \((#file as NSString).lastPathComponent)[\(#line)], \(#function): Image Downlaod error: URL Error")

            action(nil)
            completionHandler?(nil)
            return
        }

        if let localStyledImage = transformer.localStyledImage {

            action(localStyledImage)
            completionHandler?(localStyledImage)

        } else if let localOriginalImage = transformer.localOriginalImage {

            kfe_resizeImage(byOriginalImage: localOriginalImage, transformer: transformer, action: { reducedImage in

                action(reducedImage)

            }, toDisk: toDisk, completionHandler: completionHandler)

        } else {

            action(transformer.placeholderImage)

            KingfisherManager.shared.downloader.downloadImage(with: URL, options: [.backgroundDecode], progressBlock: nil) { [weak self] image, error, imageURL, originalData in

                guard let originalImage = image, let strongSelf = self else { return }

                strongSelf.kfe_resizeImage(byOriginalImage: originalImage, transformer: transformer, action: { reducedImage in

                    action(reducedImage)

                }, toDisk: toDisk, completionHandler: completionHandler)

                if toDisk {
                    KingfisherManager.shared.cache.store(originalImage, original: originalData, forKey: URL.absoluteString, toDisk: true, completionHandler: nil)
                }
            }
        }
    }
}

