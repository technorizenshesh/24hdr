//
//  TabBarVC.swift
//  24Hour User
//
//  Created by mac on 03/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height + 20)
//        tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: PredefinedConstants.appColor(), size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.init(top: 0, left: 0, bottom: 20, right: 0))
        let img = UIImage()
        img.resizableImage(withCapInsets: UIEdgeInsets.init(top: 0, left: 0, bottom: 20, right: 20))
        // remove default border
        tabBar.frame.size.width = self.view.frame.width + 4
        tabBar.frame.origin.x = -2
        UITabBar.appearance().tintColor = UIColor.white
    }
    override func viewWillAppear(_ animated: Bool) {
        if kAppDelegate.userId == "" {
            if let arrayOfTabBarItems = self.tabBar.items as AnyObject as? NSArray,let
                tabBarItem = arrayOfTabBarItems[1] as? UITabBarItem,let
                tabBarItem2 = arrayOfTabBarItems[2] as? UITabBarItem,let
                tabBarItem3 = arrayOfTabBarItems[3] as? UITabBarItem,let
                tabBarItem4 = arrayOfTabBarItems[4] as? UITabBarItem {
                tabBarItem.isEnabled = false
                tabBarItem2.isEnabled = false
                tabBarItem3.isEnabled = false
                tabBarItem4.isEnabled = false
            }
        } else {
            if let arrayOfTabBarItems = self.tabBar.items as AnyObject as? NSArray,let
                tabBarItem = arrayOfTabBarItems[1] as? UITabBarItem,let
                tabBarItem2 = arrayOfTabBarItems[2] as? UITabBarItem,let
                tabBarItem3 = arrayOfTabBarItems[3] as? UITabBarItem,let
                tabBarItem4 = arrayOfTabBarItems[4] as? UITabBarItem {
                tabBarItem.isEnabled = true
                tabBarItem2.isEnabled = true
                tabBarItem3.isEnabled = true
                tabBarItem4.isEnabled = true
            }

        }
    }

}

extension UIImage {
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
