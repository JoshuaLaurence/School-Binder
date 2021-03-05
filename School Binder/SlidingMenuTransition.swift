//
//  SlidingMenuTransition.swift
//  School Binder
//
//  Created by Joshua Laurence on 31/07/2020.
//  Copyright © 2020 Joshua Laurence. All rights reserved.
//

import UIKit

class SlidingMenuTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    //MARK: Variable Declaration
    var isPresenting = false
    let dimmingView = UIView()
    var container = UIView()
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        //MARK: ViewController & View Declaration
        let toVC = transitionContext.viewController(forKey: .to)!
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toView = toVC.view!
        let fromView = fromVC.view!
        container = transitionContext.containerView
        
        let endWidth = toView.bounds.width * 0.77
        let endHeight = toView.bounds.height
        
        //MARK: Dimming View Setup
        if isPresenting {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
            dimmingView.addGestureRecognizer(gesture)
            dimmingView.backgroundColor = .black
            dimmingView.alpha = 0.0
            container.addSubview(dimmingView)
            dimmingView.frame = container.bounds
            container.addSubview(toView)
            if UIAccessibility.prefersCrossFadeTransitions == true {
                toView.frame = CGRect(x: 0, y: 0, width: endWidth, height: endHeight)
                toView.alpha = 0
            } else {
                toView.frame = CGRect(x: -endWidth, y: 0, width: endWidth, height: endHeight)
            }
        }
        
        //MARK: Presenting Animation
        let transform = {
            self.dimmingView.alpha = 0.65
            if UIAccessibility.prefersCrossFadeTransitions == true {
                toView.alpha = 1
            } else {
                toView.transform = CGAffineTransform(translationX: endWidth, y: 0)
            }
        }
        
        //MARK: Dismissing Animation
        let identity = {
            self.dimmingView.alpha = 0.0
            if UIAccessibility.prefersCrossFadeTransitions == true {
                fromView.alpha = 0
            } else {
                fromView.transform = .identity
            }
        }
        
        //MARK: Actual Animation With Parameters
        let dur = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        if UIAccessibility.prefersCrossFadeTransitions == true {
            UIView.animate(withDuration: 0.3, animations: {
                self.isPresenting ? transform() : identity()
            }) { (_) in
                transitionContext.completeTransition(!isCancelled)
                UIApplication.shared.keyWindow?.addSubview(toView)
            }
        } else {
            UIView.animate(withDuration: dur, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.isPresenting ? transform() : identity()
            }) { (_) in
                transitionContext.completeTransition(!isCancelled)
                UIApplication.shared.keyWindow?.addSubview(toView)
            }
        }
        
    }
    
    //MARK: Dimming View Dismiss Function
    @objc func dismiss() {
        GlobalFunctions().pow()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissMenu"), object: self)
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
    
}
