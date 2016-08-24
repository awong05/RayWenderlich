//
//  PushButtonView.swift
//  Flo
//
//  Created by Andy Wong on 8/23/16.
//  Copyright © 2016 Andy Wong. All rights reserved.
//

import UIKit

@IBDesignable class PushButtonView: UIButton
{
    @IBInspectable var fillColor: UIColor = UIColor.greenColor()
    @IBInspectable var isAddButton: Bool = true

    override func drawRect(rect: CGRect)
    {
        let path = UIBezierPath(ovalInRect: rect)
        fillColor.setFill()
        path.fill()

        let plusHeight: CGFloat = 3.0
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * 0.6
        let plusPath = UIBezierPath()

        plusPath.lineWidth = plusHeight
        plusPath.moveToPoint(CGPoint(x: bounds.width / 2 - plusWidth / 2 + 0.5,
                                     y: bounds.height / 2 + 0.5))
        plusPath.addLineToPoint(CGPoint(x: bounds.width / 2 + plusWidth / 2 + 0.5,
                                        y: bounds.height / 2 + 0.5))

        if isAddButton {
            plusPath.moveToPoint(CGPoint(x: bounds.width / 2 + 0.5,
                                         y: bounds.height / 2 - plusWidth / 2 + 0.5))
            plusPath.addLineToPoint(CGPoint(x: bounds.width / 2 + 0.5,
                                            y: bounds.height / 2 + plusWidth / 2 + 0.5))
        }

        UIColor.whiteColor().setStroke()
        plusPath.stroke()
    }
}
