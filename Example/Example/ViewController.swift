//
//  ViewController.swift
//  KingfisherExtension
//
//  Created by catch on 15/11/17.
//  Copyright © 2015年 KingfisherExtension. All rights reserved.
//

import UIKit
import KingfisherExtension

class ViewController: UIViewController {

    @IBOutlet fileprivate weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInset.top = 20.0
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CollectionViewCell.kfe_className)
    }
}


extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let URLString = "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-\((indexPath as NSIndexPath).row + 1).jpg"

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.kfe_className, for: indexPath) as! CollectionViewCell

        let squareTransformer = Transformer(URLString: URLString, style: Style.square)
        let transformer1 = Transformer(URLString: URLString, style: Style.round1)
        let transformer2 = Transformer(URLString: URLString, style: Style.round2)
        let transformer3 = Transformer(URLString: URLString, style: Style.round3)

        cell.imageView.kfe_setImage(byTransformer: squareTransformer)
        cell.imageView1.kfe_setImage(byTransformer: transformer1)
        cell.imageView2.kfe_setImage(byTransformer: transformer2)
        cell.imageView3.kfe_setImage(byTransformer: transformer3)

        cell.button.kfe_setImage(byTransformer: transformer3)

        return cell
    }
}


extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenWidth, height: 100)
    }
}


