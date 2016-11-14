//
//  BookPageCell.swift
//  Paper
//
//  Created by Andy Wong on 11/13/16.
//  Copyright © 2016 Ray Wenderlich. All rights reserved.
//

import UIKit

class BookPageCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    var book: Book?
    var isRightPage = false
    var shadowLayer = CAGradientLayer()

    override var bounds: CGRect {
        didSet {
            shadowLayer.frame = bounds
        }
    }

    var image: UIImage? {
        didSet {
            let corners: UIRectCorner = isRightPage ? [.topRight, .bottomRight] : [.topLeft, .bottomLeft]
            imageView.image = image!.imageByScalingAndCroppingForSize(bounds.size).imageWithRoundedCornersSize(20, corners: corners)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupAntialiasing()
        initShadowLayer()
    }

    func setupAntialiasing() {
        layer.allowsEdgeAntialiasing = true
        imageView.layer.allowsEdgeAntialiasing = true
    }

    func initShadowLayer() {
        let shadowLayer = CAGradientLayer()

        shadowLayer.frame = bounds
        shadowLayer.startPoint = CGPoint(x: 0, y: 0.5)
        shadowLayer.endPoint = CGPoint(x: 1, y: 0.5)

        self.imageView.layer.addSublayer(shadowLayer)
        self.shadowLayer = shadowLayer
    }

    func getRatioFromTransform() -> CGFloat {
        var ratio: CGFloat = 0

        let rotationY = CGFloat(layer.value(forKeyPath: "transform.rotation.y") as! Float)
        ratio = !isRightPage ? -(1 - rotationY / CGFloat(M_PI_2)) : 1 - rotationY / CGFloat(-M_PI_2)

        return ratio
    }

    func updateShadowLayer(_ animated: Bool = false) {
        let inverseRatio = 1 - abs(getRatioFromTransform())

        if !animated {
            CATransaction.begin()
            CATransaction.setDisableActions(!animated)
        }

        if isRightPage {
            shadowLayer.colors = NSArray(objects:
                UIColor.darkGray.withAlphaComponent(inverseRatio * 0.45).cgColor,
                UIColor.darkGray.withAlphaComponent(inverseRatio * 0.40).cgColor,
                UIColor.darkGray.withAlphaComponent(inverseRatio * 0.55).cgColor
            ) as? [Any]
            shadowLayer.locations = NSArray(objects:
                NSNumber(value: 0.00),
                NSNumber(value: 0.02),
                NSNumber(value: 1.00)
            ) as? [NSNumber]
        } else {
            shadowLayer.colors = NSArray(objects:
                UIColor.darkGray.withAlphaComponent(inverseRatio * 0.30).cgColor,
                UIColor.darkGray.withAlphaComponent(inverseRatio * 0.40).cgColor,
                UIColor.darkGray.withAlphaComponent(inverseRatio * 0.50).cgColor,
                UIColor.darkGray.withAlphaComponent(inverseRatio * 0.55).cgColor
            ) as? [Any]
            shadowLayer.locations = NSArray(objects:
                NSNumber(value: 0.00),
                NSNumber(value: 0.50),
                NSNumber(value: 0.98),
                NSNumber(value: 1.00)
            ) as? [NSNumber]
        }

        if !animated {
            CATransaction.commit()
        }
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        if layoutAttributes.indexPath.item % 2 == 0 {
            layer.anchorPoint = CGPoint(x: 0, y: 0.5)
            isRightPage = true
        } else {
            layer.anchorPoint = CGPoint(x: 1, y: 0.5)
            isRightPage = false
        }

        self.updateShadowLayer()
    }
}
