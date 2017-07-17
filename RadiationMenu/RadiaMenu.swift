//
//  RadiaMenu.swift
//  RadialMenuDemo
//
//  Created by clearlove on 2017/7/7.
//  Copyright © 2017年 clearlove. All rights reserved.
//

import UIKit

@objc protocol RadialMenuDelegate {
    // 显示多少个小球
    func numberOfItemsInRadialMenu(menu:RadiaMenu) -> Int
    //小球旋转角度
    func sizeForRadialMenu(menu:RadiaMenu) -> CGFloat

    //menu的半径
    func radiusForRadialMenu(menu:RadiaMenu) -> CGFloat

    /// 每个小球的图片
    ///
    /// - Parameters:
    ///   - menu: menu
    ///   - imageForIndex: 每个小球的索引
    /// - Returns: 每个小球的图片
    func itemImage(menu:RadiaMenu,imageForIndex:Int) -> UIImage
    
  
    /// 点击小球的事件
    ///
    /// - Parameters:
    ///   - menu: menu
    ///   - selectIndex: 索引
    func didSelectMenu(menu:RadiaMenu,selectIndex:Int)
    //起始角度
    func startForRadiaMenu(menu:RadiaMenu) -> CGFloat
    
}


class RadiaMenu: UIView,RadialButtonDelegate {

    var delegate:RadialMenuDelegate?
    
    var itemIndex:Int = 0
    
    var timer:Timer?
    
    var itemsArr:Array = [Any]()
    
    
  
    //按钮旋转动画
    fileprivate func shouldRotateButton(button:UIButton,duration:CGFloat,direction:Bool) {
        let spinAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        spinAnimation.duration = CFTimeInterval(duration)
        spinAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        var totalDuration = Double.pi * Double(itemsArr.count)
        if !direction {
            totalDuration = totalDuration * -1.0
        }
        spinAnimation.toValue = totalDuration
        button.layer.add(spinAnimation, forKey: "spinAnimation")
    }
    
    func itemsWillAppearFromButtonAndInView(button:UIButton,view:UIView) {
        if itemsArr.count > 0 {
            return
        }
        let itemCount = delegate?.numberOfItemsInRadialMenu(menu: self)
        if itemCount == 0 {
            return
        }
        var mutablePopups:[Any] = []
        var arc = delegate?.sizeForRadialMenu(menu: self)
        if arc == 0 {
            arc = 90
        }
        var radius = delegate?.radiusForRadialMenu(menu: self)
        if radius! < CGFloat(1) {
            radius = 80
        }
        
        let start = delegate?.startForRadiaMenu(menu: self)
        
        let angle = arc! / CGFloat(itemCount!)
        let centerX = button.center.x
        let centerY = button.center.y
        let origin = CGPoint(x: centerX, y: centerY)
        var currentItem = 1
        var popupButton = RadialButton()
        
        while currentItem <= itemCount! {
            let radians = (angle * CGFloat((currentItem - 1)) + start!) * CGFloat(Double.pi / 180)
            let x = round(centerX + radius! * cos(radians))
            let y = round(centerY + radius! * sin(radians))
            
            let extraX = round(centerX + (radius! * 1.07) * cos(radians))
            let extraY = round(centerY + (radius! * 1.07) * sin(radians))
            let frame = CGRect(x: centerX, y: centerY, width: 25, height: 25)
            let final = CGPoint(x: x, y: y)
            let bounce = CGPoint(x: extraX, y: extraY)
            
            popupButton = RadialButton(frame: frame)
            popupButton.alpha = 0.0
            popupButton.centerPoint = final
            popupButton.bouncePoint = bounce
            popupButton.originPoint = origin
            popupButton.delegate = self
            popupButton.tag = currentItem
            popupButton.setImage(delegate?.itemImage(menu: self, imageForIndex: currentItem), for: .normal)
            popupButton.addTarget(self, action: #selector(buttonPressed(button:)), for: .touchUpInside)
            view.insertSubview(popupButton, belowSubview: button)
            mutablePopups.append(popupButton)
            currentItem += 1
        }
        itemsArr = mutablePopups
        itemIndex = 0
        let maxDuration = 0.5
        let flingInterval = maxDuration / Double(itemsArr.count)
        
        
        timer = Timer.scheduledTimer(timeInterval: flingInterval, target: self, selector: #selector(willFlingItem), userInfo: nil, repeats: true)
        timer?.fire()
        
        let spinDuration = Double(itemsArr.count + 1) * flingInterval
        shouldRotateButton(button: button, duration: CGFloat(spinDuration), direction: true)

    }
    
    //按钮点击事件
    func buttonPressed(button:RadialButton) {
        delegate?.didSelectMenu(menu: self, selectIndex: button.tag)
    }
    
    
    
    func itemsWillDisaperIntoButton(button:UIButton) {
        if itemsArr.count == 0 {
            return
         
        }else{
            
            let maxDuration = 0.5
            let flingInterval = maxDuration / Double(itemsArr.count)
            timer = Timer.scheduledTimer(timeInterval: flingInterval, target: self, selector: #selector(willRecoilItem), userInfo: nil, repeats: true)
            timer?.fire()
          
            let spinDuration = Double(itemsArr.count + 1) * flingInterval
            shouldRotateButton(button: button, duration: CGFloat(spinDuration), direction: false)
        }
        
       
        
    }
    
    func buttonsWillAnimateFormButton(button:UIButton,inView:UIView)  {
        
        if itemsArr.count > 0 {
            itemsWillDisaperIntoButton(button: button)
        }else{
            itemsWillAppearFromButtonAndInView(button: button, view: inView)
        }
    }
    //甩出动作
    func willFlingItem() {
        if itemIndex == itemsArr.count {

            timer?.invalidate()
            timer = nil
            return
        }
        
        let button:RadialButton = itemsArr[itemIndex] as! RadialButton
        button.willAppear()
        
        itemIndex += 1
    }
    //弹回动作
    func willRecoilItem() {
        
        if itemIndex == 0 {
            timer?.invalidate()
            timer = nil
            return
        }
        itemIndex -= 1
        let button:RadialButton = itemsArr[itemIndex] as! RadialButton
        button.willDisapper()
    }

    //MARK: -- RadialButtonDelegate
    func buttonDidFinishAnimation(button: RadialButton) {
        button.removeFromSuperview()
        if button.tag == 1 {
            itemsArr.removeAll()
      
        }
    }

}
