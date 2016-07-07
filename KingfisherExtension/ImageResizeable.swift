//
//  ImageResizeable.swift
//  Example
//
//  Created by Limon on 7/7/16.
//  Copyright © 2016 KingfisherExtension. All rights reserved.
//

import Kingfisher

protocol ImageResizeable {
    func resizeImage(byOriginalImage originalImage: UIImage, transformer: ImageReducible, action: (reducedImage: UIImage) -> Void, completionHandler: ((image: UIImage?) -> Void)?)
}


extension ImageResizeable where Self: UIView {

    func resizeImage(byOriginalImage originalImage: UIImage, transformer: ImageReducible, action: (reducedImage: UIImage) -> Void, completionHandler: ((image: UIImage?) -> Void)?) {

        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {

            let reducedImage = originalImage.navi_avatarImageWithStyle(transformer.style)

            KingfisherManager.sharedManager.cache.storeImage(reducedImage, originalData: nil, forKey: transformer.key, toDisk: true, completionHandler: {

                dispatch_async(dispatch_get_main_queue()) {

                    UIView.transitionWithView(self, duration: 0.3, options: .TransitionCrossDissolve, animations: {

                        action(reducedImage: reducedImage)

                    }, completion: { _ in

                        completionHandler?(image: reducedImage)
                    })

                }

            })

        }
    }
}

