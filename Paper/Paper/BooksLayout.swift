//
//  BooksLayout.swift
//  Paper
//
//  Created by Andy Wong on 11/13/16.
//  Copyright © 2016 Ray Wenderlich. All rights reserved.
//

import UIKit

fileprivate let PageWidth: CGFloat = 362
fileprivate let PageHeight: CGFloat = 568

class BooksLayout: UICollectionViewFlowLayout {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        scrollDirection = UICollectionViewScrollDirection.horizontal
        itemSize = CGSize(width: PageWidth, height: PageHeight)
        minimumInteritemSpacing = 10
    }

    override func prepare() {
        super.prepare()

        collectionView?.decelerationRate = UIScrollViewDecelerationRateFast

        collectionView?.contentInset = UIEdgeInsets(top: 0, left: collectionView!.bounds.width / 2 - PageWidth / 2, bottom: 0, right: collectionView!.bounds.width / 2 - PageWidth / 2)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let array = super.layoutAttributesForElements(in: rect)!

        for attributes in array {
            let frame = attributes.frame
            let distance = abs(collectionView!.contentOffset.x + collectionView!.contentInset.left - frame.origin.x)
            let scale = 0.7 * min(max(1 - distance / (collectionView!.bounds.width), 0.75), 1)
            attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
        }

        return array
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var newOffset = CGPoint()
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        let width = layout.itemSize.width + layout.minimumLineSpacing
        var offset = proposedContentOffset.x + collectionView!.contentInset.left

        if velocity.x > 0 {
            offset = width * ceil(offset / width)
        } else if velocity.x == 0 {
            offset = width * round(offset / width)
        } else if velocity.x < 0 {
            offset = width * floor(offset / width)
        }

        newOffset.x = offset
        newOffset.y = proposedContentOffset.y
        return newOffset
    }
}
