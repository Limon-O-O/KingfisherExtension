//
//  ViewController.swift
//  KingfisherExtension
//
//  Created by catch on 15/11/17.
//  Copyright © 2015年 KingfisherExtension. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!

    let cellID = "CollectionViewCell"

    let avatarURLStrings = [
        "http://7xkszy.com2.z0.glb.qiniucdn.com/pics/avatars/u8516711441533445.jpg?imageView2/1/w/128/h/128",
        "https://abs.twimg.com/sticky/default_profile_images/default_profile_6_400x400.png",
        "https://pbs.twimg.com/profile_images/647082562125459456/pmT48eHQ_400x400.jpg",
        "https://www.gravatar.com/avatar/bdbb982ff5d7f08fce5b515b2db5f998?s=64&d=identicon&r=PG&f=1",
        "https://pbs.twimg.com/profile_images/188302352/nasalogo_twitter_400x400.jpg",
        "http://tp2.sinaimg.cn/1885190365/180/1292238800/1",
        "http://tp4.sinaimg.cn/2463797455/180/5720402811/1"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.registerNib(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellID)
    }

}


extension ViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatarURLStrings.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! CollectionViewCell
        cell.imageView.kfe_setRoundImageWithURLString(avatarURLStrings[indexPath.row], cornerRadiusRatio: 0.25)
        return cell
    }
}


extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: ScreenWidth, height: 200)
    }
}


let ScreenBounds = UIScreen.mainScreen().bounds
let ScreenWidth = ceil(UIScreen.mainScreen().bounds.size.width)
let ScreenHeight = ceil(UIScreen.mainScreen().bounds.size.height)

