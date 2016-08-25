//
//  ViewController.swift
//  Flo
//
//  Created by Andy Wong on 8/23/16.
//  Copyright © 2016 Andy Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var counterView: CounterView!
    @IBOutlet weak var counterLabel: UILabel!

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var graphView: GraphView!

    @IBOutlet weak var averageWaterDrunk: UILabel!
    @IBOutlet weak var maxLabel: UILabel!

    private var isGraphViewShowing = false

    override func viewDidLoad()
    {
        super.viewDidLoad()
        counterLabel.text = "\(counterView.counter)"
    }

    func setupGraphDisplay()
    {
        let noOfDays = 7

        graphView.graphPoints[graphView.graphPoints.count - 1] = counterView.counter
        graphView.setNeedsDisplay()
        maxLabel.text = "\(graphView.graphPoints.maxElement()!)"

        let average = graphView.graphPoints.reduce(0, combine: +) / graphView.graphPoints.count
        averageWaterDrunk.text = "\(average)"

        let dateFormatter = NSDateFormatter()
        let calendar = NSCalendar.currentCalendar()
        let componentOptions: NSCalendarUnit = .Weekday
        let components = calendar.components(componentOptions, fromDate: NSDate())

        var weekday = components.weekday

        let days = ["S", "S", "M", "T", "W", "T", "F"]

        for i in (1...days.count).reverse() {
            if let labelView = graphView.viewWithTag(i) as? UILabel {
                if weekday == 7 {
                    weekday = 0
                }
                labelView.text = days[weekday]
                weekday -= 1
                if weekday < 0 {
                    weekday = days.count - 1
                }
            }
        }
    }

    @IBAction func btnPushButton(button: PushButtonView)
    {
        if button.isAddButton {
            counterView.counter += 1
        } else {
            if counterView.counter > 0 {
                counterView.counter -= 1
            }
        }
        counterLabel.text = "\(counterView.counter)"

        if isGraphViewShowing {
            counterViewTap(nil)
        }
    }

    @IBAction func counterViewTap(gesture: UITapGestureRecognizer?)
    {
        if isGraphViewShowing {
            UIView.transitionFromView(graphView,
                                      toView: counterView,
                                      duration: 1.0,
                                      options: [.TransitionFlipFromLeft,
                                                .ShowHideTransitionViews],
                                      completion: nil)
        } else {
            UIView.transitionFromView(counterView,
                                      toView: graphView,
                                      duration: 1.0,
                                      options: [.TransitionFlipFromRight,
                                                .ShowHideTransitionViews],
                                      completion: nil)

            setupGraphDisplay()
        }
        isGraphViewShowing = !isGraphViewShowing
    }
}
