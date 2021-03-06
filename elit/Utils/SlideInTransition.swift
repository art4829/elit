//
//  SlideInTransition.swift
//  elit
//
//  Created by Abigail Tran and Abhaya Tamrakar on 4/14/20.
//  Copyright © 2020 Abigail Tran and Abhaya Tamrakar. All rights reserved.
//


import UIKit

class SlideInTransition: NSObject, UIViewControllerAnimatedTransitioning {

    var isPresenting = false
    let dimmingView = UIView()

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from) else { return }

        let containerView = transitionContext.containerView

        let finalWidth = toViewController.view.bounds.width * 0.6
        let tHeight = toViewController.tabBarController?.tabBar.frame.height ?? CGFloat(TAB_BAR_HEIGHT)
        let finalHeight = toViewController.view.bounds.height - tHeight
        
        if isPresenting {
            // Add dimming view
            dimmingView.backgroundColor = .black
            dimmingView.alpha = 0.0
            containerView.addSubview(dimmingView)
            dimmingView.frame = containerView.bounds
            // Add menu view controller to container
            containerView.addSubview(toViewController.view)
            let safe = toViewController.view.safeAreaInsets
            // Init frame off the screen
            toViewController.view.frame = CGRect(x: -finalWidth, y: safe.top, width: finalWidth, height: finalHeight - safe.top - safe.bottom)
        }

        // Move on screen
        let transform = {
            self.dimmingView.alpha = 0.5
            toViewController.view.transform = CGAffineTransform(translationX: finalWidth, y: 0)
        }


        // Move back off screen
        let identity = {
            self.dimmingView.alpha = 0.0
            fromViewController.view.transform = .identity
        }

        // Animation of the transition
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        UIView.animate(withDuration: duration, animations: {
            self.isPresenting ? transform() : identity()
        }) { (_) in
            transitionContext.completeTransition(!isCancelled)
        }
    }

}

