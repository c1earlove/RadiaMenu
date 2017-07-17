//
//  RadialButton.swift
//  RadialMenuDemo
//
//  Created by clearlove on 2017/7/7.
//  Copyright © 2017年 clearlove. All rights reserved.
//

import UIKit

protocol RadialButtonDelegate {
    //动画完成
    func buttonDidFinishAnimation(button:RadialButton)

}

class RadialButton: UIButton {

    var delegate:RadialButtonDelegate?
    var centerPoint:CGPoint?
    var bouncePoint:CGPoint?
    var originPoint:CGPoint?
    
    func willAppear() {
      
        self.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(180.0 / 180.0 * .pi))
        self.alpha = 1.0
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: { 
            
            self.center = self.bouncePoint!
            self.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(0 / 180.0 * .pi))
            
        }) { (finished) in
            
            UIView.animate(withDuration: 0.15, animations: { 
                self.center = self.centerPoint!
            })
            
            
        }
        
    }
    
    func willDisapper() -> () {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveLinear, animations: { 
            
             self.imageView?.transform = CGAffineTransform(rotationAngle: -CGFloat(0 / 180.0 * .pi))
            
        }) { (finished) in
            
            UIView.animate(withDuration: 0.25, animations: { 
                self.center = self.originPoint!
            }, completion: { (finished) in
                self.alpha = 0
                self.delegate?.buttonDidFinishAnimation(button: self)
            })
            
        }
    }
    
}
