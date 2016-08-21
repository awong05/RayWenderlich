//
//  ViewController.swift
//  DynamicsDemo
//
//  Created by Andy Wong on 8/21/16.
//  Copyright © 2016 Andy Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate
{
    private var animator: UIDynamicAnimator!
    private var gravity: UIGravityBehavior!
    private var collision: UICollisionBehavior!

    //private var firstContact = false

    private var square: UIView!
    private var snap: UISnapBehavior!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        square = UIView(frame: CGRect(x: 100,
                                          y: 100,
                                          width: 100,
                                          height: 100))
        square.backgroundColor = UIColor.grayColor()
        view.addSubview(square)

        let barrier = UIView(frame: CGRect(x: 0,
                                           y: 300,
                                           width: 130,
                                           height: 20))
        barrier.backgroundColor = UIColor.redColor()
        view.addSubview(barrier)

        animator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [square])
        animator.addBehavior(gravity)

        collision = UICollisionBehavior(items: [square])
        collision.collisionDelegate = self
        collision.addBoundaryWithIdentifier("barrier",
                                            forPath: UIBezierPath(rect: barrier.frame))
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)

        let itemBehaviour = UIDynamicItemBehavior(items: [square])
        itemBehaviour.elasticity = 0.6
        animator.addBehavior(itemBehaviour)

        /*
        var updateCount = 0
        collision.action = {
            if (updateCount % 3 == 0) {
                let outline = UIView(frame: square.bounds)
                outline.transform = square.transform
                outline.center = square.center

                outline.alpha = 0.5
                outline.backgroundColor = UIColor.clearColor()
                outline.layer.borderColor = square.layer.presentationLayer()!.backgroundColor
                outline.layer.borderWidth = 1.0
                self.view.addSubview(outline)
            }
            updateCount += 1
        }
        */
    }

    func collisionBehavior(behavior: UICollisionBehavior,
                           beganContactForItem item: UIDynamicItem,
                           withBoundaryIdentifier identifier: NSCopying?,
                           atPoint p: CGPoint)
    {
        let collidingView = item as! UIView
        collidingView.backgroundColor = UIColor.yellowColor()
        UIView.animateWithDuration(0.3) {
            collidingView.backgroundColor = UIColor.grayColor()
        }

        /*
        if !firstContact {
            firstContact = true

            let square = UIView(frame: CGRect(x: 30, y: 0, width: 100, height: 100))
            square.backgroundColor = UIColor.grayColor()
            view.addSubview(square)

            collision.addItem(square)
            gravity.addItem(square)

            let attach = UIAttachmentBehavior(item: collidingView, attachedToItem: square)
            animator.addBehavior(attach)
        }
        */
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if snap != nil {
            animator.removeBehavior(snap)
        }

        let touch = touches.first!
        snap = UISnapBehavior(item: square, snapToPoint: touch.locationInView(view))
        animator.addBehavior(snap)
    }
}
