//
//  UIImage+Helpers.swift
//  Paper
//
//  Created by Andy Wong on 11/13/16.
//  Copyright © 2016 Ray Wenderlich. All rights reserved.
//

import UIKit

extension UIImage {
    func imageWithRoundedCornersSize(_ cornerRadius: CGFloat, corners: UIRectCorner) -> UIImage {
        UIGraphicsBeginImageContext(self.size)

        UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height), byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).addClip()
        draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return image
    }

    func imageByScalingAndCroppingForSize(_ targetSize: CGSize) -> UIImage {
        let sourceImage = self
        var newImage = UIImage()
        let imageSize = sourceImage.size
        let width = imageSize.width
        let height = imageSize.height
        let targetWidth = targetSize.width
        let targetHeight = targetSize.height
        var scaleFactor: CGFloat = 0.0
        var scaledWidth = targetWidth
        var scaledHeight = targetHeight
        var thumbnailPoint = CGPoint(x: 0.0, y: 0.0)

        if !__CGSizeEqualToSize(imageSize, targetSize) {
            let widthFactor = targetWidth / width
            let heightFactor = targetHeight / height

            scaleFactor = widthFactor > heightFactor ? widthFactor : heightFactor
            scaledWidth = width * scaleFactor
            scaledHeight = height * scaleFactor

            if widthFactor > heightFactor {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
            } else if widthFactor < heightFactor {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
            }
        }

        UIGraphicsBeginImageContext(targetSize)

        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaledWidth
        thumbnailRect.size.height = scaledHeight

        sourceImage.draw(in: thumbnailRect)

        newImage = UIGraphicsGetImageFromCurrentImageContext()!

        UIGraphicsEndImageContext()

        return newImage
    }
}
