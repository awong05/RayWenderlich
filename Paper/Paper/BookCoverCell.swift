//
//  BookCoverCell.swift
//  Paper
//
//  Created by Andy Wong on 11/13/16.
//  Copyright © 2016 Ray Wenderlich. All rights reserved.
//

import UIKit

class BookCoverCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    var book: Book? {
        didSet {
            image = book?.coverImage()
        }
    }

    var image: UIImage? {
        didSet {
            let corners: UIRectCorner = [.topRight, .bottomRight]
            imageView.image = image!.imageByScalingAndCroppingForSize(bounds.size).imageWithRoundedCornersSize(20, corners: corners)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
