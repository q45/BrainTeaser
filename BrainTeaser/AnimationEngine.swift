//
//  AnimationEngine.swift
//  BrainTeaser
//
//  Created by Quintin Smith on 3/17/16.
//  Copyright © 2016 wasatchcode. All rights reserved.
//

import UIKit
import pop

class AnimationEngine {
    
    class var offScreenRightPosition: CGPoint {
       return CGPointMake(UIScreen.mainScreen().bounds.width, CGRectGetMidY(UIScreen.mainScreen().bounds))
    }
    
    class var offScreenLeftPosition: CGPoint {
        return CGPointMake(-UIScreen.mainScreen().bounds.width, CGRectGetMidY(UIScreen.mainScreen().bounds))
    }
    
    class var screenCenterPosition: CGPoint {
        return CGPointMake(CGRectGetMidX(UIScreen.mainScreen().bounds), CGRectGetMidY(UIScreen.mainScreen().bounds))
    }
    
    let ANIMDELAY: Int = 1
    var originalConstants = [CGFloat]()
    var constraints: [NSLayoutConstraint]
    
    init(constraints: [NSLayoutConstraint]) {
        for con in constraints {
             originalConstants.append(con.constant)
             con.constant = AnimationEngine.offScreenRightPosition.x
        }
        self.constraints = constraints
    }
    
    func animateOnScreen(delay: Int) {
        
//        let d: Int64 = delay == nil ? Int64(Double(ANIMDELAY) * Double(NSEC_PER_SEC)) : delay!
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(delay) * Double(NSEC_PER_SEC)))
        
        dispatch_after(time, dispatch_get_main_queue()) {
            var index = 0
            repeat {
                let moveAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
                moveAnim.toValue = self.originalConstants[index]
                moveAnim.springBounciness = 15
                moveAnim.springSpeed = 5
                
            if (index > 0) {
                moveAnim.dynamicsFriction += 2 + CGFloat(index)
            }
            
                let con = self.constraints[index]
                con.pop_addAnimation(moveAnim, forKey: "moveOnScreen")
                index++
                
            } while (index < self.constraints.count)
            
        }
        
    }
    
}
