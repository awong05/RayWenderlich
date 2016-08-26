//
//  ViewController.swift
//  DynamicToss
//
//  Created by Andy Wong on 8/25/16.
//  Copyright © 2016 Andy Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var redSquare: UIView!
    @IBOutlet weak var blueSquare: UIView!

    private var originalBounds = CGRect.zero
    private var originalCenter = CGPoint.zero

    private var animator: UIDynamicAnimator!
    private var attachmentBehavior: UIAttachmentBehavior!
    private var pushBehavior: UIPushBehavior!
    private var itemBehavior: UIDynamicItemBehavior!

    private let ThrowingThreshold: CGFloat = 1000
    private let ThrowingVelocityPadding: CGFloat = 35

    override func viewDidLoad()
    {
        super.viewDidLoad()

        animator = UIDynamicAnimator(referenceView: view)
        originalBounds = imageView.bounds
        originalCenter = imageView.center
    }

    private func resetDemo()
    {
        animator.removeAllBehaviors()

        UIView.animateWithDuration(0.45) {
            self.imageView.bounds = self.originalBounds
            self.imageView.center = self.originalCenter
            self.imageView.transform = CGAffineTransformIdentity
        }
    }

    @IBAction func handleAttachmentGesture(sender: UIPanGestureRecognizer)
    {
        let location = sender.locationInView(view)
        let boxLocation = sender.locationInView(imageView)

        switch sender.state {
        case .Began:
            animator.removeAllBehaviors()

            let centerOffset = UIOffset(horizontal: boxLocation.x - imageView.bounds.midX,
                                        vertical: boxLocation.y - imageView.bounds.midY)

            attachmentBehavior = UIAttachmentBehavior(item: imageView,
                                                      offsetFromCenter: centerOffset,
                                                      attachedToAnchor: location)

            redSquare.center = attachmentBehavior.anchorPoint
            blueSquare.center = location

            animator.addBehavior(attachmentBehavior)
        case .Ended:
            animator.removeAllBehaviors()

            let velocity = sender.velocityInView(view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))

            if magnitude > ThrowingThreshold {
                let pushBehavior = UIPushBehavior(items: [imageView], mode: .Instantaneous)
                pushBehavior.pushDirection = CGVector(dx: velocity.x / 10, dy: velocity.y / 10)
                pushBehavior.magnitude = magnitude / ThrowingVelocityPadding

                self.pushBehavior = pushBehavior
                animator.addBehavior(pushBehavior)

                let angle = Int(arc4random_uniform(20)) - 10

                itemBehavior = UIDynamicItemBehavior(items: [imageView])
                itemBehavior.friction = 0.2
                itemBehavior.allowsRotation = true
                itemBehavior.addAngularVelocity(CGFloat(angle), forItem: imageView)
                animator.addBehavior(itemBehavior)

                let timeOffset = Int64(0.4 * Double(NSEC_PER_SEC))
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, timeOffset), dispatch_get_main_queue()) {
                    self.resetDemo()
                }
            } else {
                resetDemo()
            }
        default:
            attachmentBehavior.anchorPoint = sender.locationInView(view)
            redSquare.center = attachmentBehavior.anchorPoint
        }
    }
}
