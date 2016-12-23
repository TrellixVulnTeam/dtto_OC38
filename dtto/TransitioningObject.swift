//
//  TransitioningObject.swift
//  dtto
//
//  Created by Jitae Kim on 12/11/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit

class TransitioningObject: NSObject, UIViewControllerAnimatedTransitioning {
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromView: UIView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView: UIView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        transitionContext.containerView.addSubview(fromView)
        transitionContext.containerView.addSubview(toView)
        
        UIView.transition(from: fromView, to: toView, duration: transitionDuration(using: transitionContext), options: UIViewAnimationOptions.transitionCrossDissolve) { finished in
            transitionContext.completeTransition(true)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
}
