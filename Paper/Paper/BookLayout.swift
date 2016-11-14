//
//  BookLayout.swift
//  Paper
//
//  Created by Andy Wong on 11/13/16.
//  Copyright © 2016 Ray Wenderlich. All rights reserved.
//

import UIKit

fileprivate let PageWidth: CGFloat = 362
fileprivate let PageHeight: CGFloat = 568
fileprivate var numberOfItems = 0

class BookLayout: UICollectionViewFlowLayout {
    override var collectionViewContentSize: CGSize {
        return CGSize(width: (CGFloat(numberOfItems / 2)) * collectionView!.bounds.width, height: collectionView!.bounds.height)
    }

    override func prepare() {
        super.prepare()
        collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        numberOfItems = collectionView!.numberOfItems(inSection: 0)
        collectionView?.isPagingEnabled = true
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var array = [UICollectionViewLayoutAttributes]()

        for i in 0...max(0, numberOfItems - 1) {
            let indexPath = IndexPath(item: i, section: 0)
            let attributes = layoutAttributesForItem(at: indexPath)

            if attributes != nil {
                array.append(attributes!)
            }
        }

        return array
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

        let frame = getFrame(collectionView!)
        layoutAttributes.frame = frame

        let ratio = getRatio(collectionView!, indexPath: indexPath)

        if ratio > 0 && indexPath.item % 2 == 1 || ratio < 0 && indexPath.item % 2 == 0 {
            if indexPath.row != 0 {
                return nil
            }
        }

        let rotation = getRotation(indexPath, ratio: min(max(ratio, -1), 1))
        layoutAttributes.transform3D = rotation

        if indexPath.row == 0 {
            layoutAttributes.zIndex = Int.max
        }

        return layoutAttributes
    }

    func getFrame(_ collectionView: UICollectionView) -> CGRect {
        var frame = CGRect()

        frame.origin.x = (collectionView.bounds.width / 2) - (PageWidth / 2) + collectionView.contentOffset.x
        frame.origin.y = (collectionViewContentSize.height - PageHeight) / 2
        frame.size.width = PageWidth
        frame.size.height = PageHeight

        return frame
    }

    func getRatio(_ collectionView: UICollectionView, indexPath: IndexPath) -> CGFloat {
        let page = CGFloat(indexPath.item - indexPath.item % 2) * 0.5
        var ratio: CGFloat = -0.5 + page - (collectionView.contentOffset.x / collectionView.bounds.width)

        if ratio > 0.5 {
            ratio = 0.5 + 0.1 * (ratio - 0.5)
        } else if ratio < -0.5 {
            ratio = -0.5 + 0.1 * (ratio + 0.5)
        }

        return ratio
    }

    func getAngle(_ indexPath: IndexPath, ratio: CGFloat) -> CGFloat {
        var angle = indexPath.item % 2 == 0 ? (1 - ratio) * CGFloat(-M_PI_2) : (1 + ratio) * CGFloat(M_PI_2)

        angle += CGFloat(indexPath.row % 2) / 1000

        return angle
    }

    func makePerspectiveTransform() -> CATransform3D {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -2000
        return transform
    }

    func getRotation(_ indexPath: IndexPath, ratio: CGFloat) -> CATransform3D {
        var transform = makePerspectiveTransform()
        let angle = getAngle(indexPath, ratio: ratio)
        transform = CATransform3DRotate(transform, angle, 0, 1, 0)
        return transform
    }
}
