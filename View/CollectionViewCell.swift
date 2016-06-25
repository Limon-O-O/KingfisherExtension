//
//  CollectionViewCell.swift
//  KingfisherExtension
//
//  Created by catch on 15/11/18.
//  Copyright © 2015年 KingfisherExtension. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 20.0

            imageView.layer.shadowColor = UIColor.redColor().CGColor
            imageView.layer.shadowOffset = CGSizeMake(0, 1)
            imageView.layer.shadowOpacity = 1.0
            imageView.layer.shadowRadius = 20.0
            imageView.layer.shadowPath = UIBezierPath(rect: imageView.bounds).CGPath
        }
    }

    @IBOutlet weak var imageView1: UIImageView! {
        didSet {
            imageView1.layer.masksToBounds = true
            imageView1.layer.cornerRadius = 20.0

            imageView1.layer.shadowColor = UIColor.redColor().CGColor
            imageView1.layer.shadowOffset = CGSizeMake(0, 1)
            imageView1.layer.shadowOpacity = 1.0
            imageView1.layer.shadowRadius = 20.0
        }
    }

    @IBOutlet weak var imageView2: UIImageView! {
        didSet {
            imageView2.layer.masksToBounds = true
            imageView2.layer.cornerRadius = 20.0

            imageView2.layer.shadowColor = UIColor.redColor().CGColor
            imageView2.layer.shadowOffset = CGSizeMake(0, 1)
            imageView2.layer.shadowOpacity = 1.0
            imageView2.layer.shadowRadius = 20.0
        }
    }

    @IBOutlet weak var imageView3: UIImageView! {
        didSet {
            imageView3.layer.masksToBounds = true
            imageView3.layer.cornerRadius = 20.0
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
