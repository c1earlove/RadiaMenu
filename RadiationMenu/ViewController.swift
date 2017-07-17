//
//  ViewController.swift
//  RadiationMenu
//
//  Created by clearlove on 2017/7/14.
//  Copyright © 2017年 clearlove. All rights reserved.
//

import UIKit

class ViewController: UIViewController,RadialMenuDelegate {

    var radiaMenu:RadiaMenu?
    override func viewDidLoad() {
        super.viewDidLoad()
        radiaMenu = RadiaMenu()
        radiaMenu?.delegate = self
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 375 - 28, y: 667 - 58, width: 22, height: 22)
        btn.setBackgroundImage(UIImage(named: "addthis500"), for: .normal)
        view.addSubview(btn)
        btn.tag = 999
        btn.addTarget(self, action: #selector(radialMenuClick(button:)), for: .touchUpInside)

    }
    
    // 按钮点击
    func radialMenuClick(button:UIButton) {
        radiaMenu?.buttonsWillAnimateFormButton(button: button, inView: view)
    }
    
    //有几个小球
    func numberOfItemsInRadialMenu(menu: RadiaMenu) -> Int {
        return 9
    }
    //起始角度
    func startForRadiaMenu(menu: RadiaMenu) -> CGFloat {
        return -180.0
    }
    //小球旋转角度
    func sizeForRadialMenu(menu: RadiaMenu) -> CGFloat {
        return 100.0
    }
    //半径
    func radiusForRadialMenu(menu: RadiaMenu) -> CGFloat {
        return 180.0
    }
    //每个小球的图片
    func itemImage(menu: RadiaMenu, imageForIndex: Int) -> UIImage {
        switch imageForIndex {
        case 1:
            return UIImage(named: "dribbble")!
        case 2:
            return UIImage(named: "youtube")!
            
        case 3:
            return UIImage(named: "vimeo")!
            
        case 4:
            return UIImage(named: "pinterest")!
        case 5:
            return UIImage(named: "twitter")!
        case 6:
            return UIImage(named: "instagram500")!
        case 7:
            return UIImage(named: "email")!
        case 8:
            return UIImage(named: "googleplus-revised")!
        case 9:
            return UIImage(named: "facebook500")!
            
        default:
            return UIImage()
        }
        
    }
    //点击每个小球的回调
    func didSelectMenu(menu: RadiaMenu, selectIndex: Int) {
        print(selectIndex)
        radiaMenu?.itemsWillDisaperIntoButton(button: view.viewWithTag(999) as! UIButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

