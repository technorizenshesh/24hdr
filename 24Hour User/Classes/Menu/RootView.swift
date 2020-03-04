//
//  RootViewCustomer.swift
//  Pallardy Place
//
//  Created by Kamal on 04/12/17.
//  Copyright © 2017 Anil. All rights reserved.
//

import UIKit

class RootView: RESideMenu, RESideMenuDelegate {
    
    override func viewDidLoad() {
        
        self.contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC")
        self.leftMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "Menu")
        super.viewDidLoad()
        
        //        self.contentViewShadowColor = UIColor.black
        //        self.contentViewShadowOffset = CGSize(width: 0, height: 0)
        //        self.contentViewShadowOpacity = 0.6
        //        self.contentViewShadowRadius = 12
        //        self.contentViewShadowEnabled = true
        //        self.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        extraAttributes()
    }
    
    
    @IBAction func left(_ sender: Any) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    @IBAction func right(_ sender: Any) {
        self.sideMenuViewController.presentRightMenuViewController()
    }
    
    func sideMenu(_ sideMenu: RESideMenu!, willShowMenuViewController menuViewController: UIViewController!) {
    }
    
    func sideMenu(_ sideMenu: RESideMenu!, didShowMenuViewController menuViewController: UIViewController!) {
        
    }
    
    func sideMenu(_ sideMenu: RESideMenu!, willHideMenuViewController menuViewController: UIViewController!) {
    }
    
    
    func sideMenu(_ sideMenu: RESideMenu!, didHideMenuViewController menuViewController: UIViewController!) {
    }
    
    
    
    func extraAttributes() {
        /**
         @property (assign, readwrite, nonatomic) NSTimeInterval animationDuration;
         @property (strong, readwrite, nonatomic) UIImage *backgroundImage;
         @property (assign, readwrite, nonatomic) BOOL panGestureEnabled;
         @property (assign, readwrite, nonatomic) BOOL panFromEdge;
         @property (assign, readwrite, nonatomic) NSUInteger panMinimumOpenThreshold;
         @property (assign, readwrite, nonatomic) BOOL interactivePopGestureRecognizerEnabled;
         @property (assign, readwrite, nonatomic) BOOL scaleContentView;
         @property (assign, readwrite, nonatomic) BOOL scaleBackgroundImageView;
         @property (assign, readwrite, nonatomic) BOOL scaleMenuView;
         @property (assign, readwrite, nonatomic) BOOL contentViewShadowEnabled;
         @property (assign, readwrite, nonatomic) UIColor *contentViewShadowColor;
         @property (assign, readwrite, nonatomic) CGSize contentViewShadowOffset;
         @property (assign, readwrite, nonatomic) CGFloat contentViewShadowOpacity;
         @property (assign, readwrite, nonatomic) CGFloat contentViewShadowRadius;
         @property (assign, readwrite, nonatomic) CGFloat contentViewScaleValue;
         @property (assign, readwrite, nonatomic) CGFloat contentViewInLandscapeOffsetCenterX;
         @property (assign, readwrite, nonatomic) CGFloat contentViewInPortraitOffsetCenterX;
         @property (assign, readwrite, nonatomic) CGFloat parallaxMenuMinimumRelativeValue;
         @property (assign, readwrite, nonatomic) CGFloat parallaxMenuMaximumRelativeValue;
         @property (assign, readwrite, nonatomic) CGFloat parallaxContentMinimumRelativeValue;
         @property (assign, readwrite, nonatomic) CGFloat parallaxContentMaximumRelativeValue;
         @property (assign, readwrite, nonatomic) CGAffineTransform menuViewControllerTransformation;
         @property (assign, readwrite, nonatomic) BOOL parallaxEnabled;
         @property (assign, readwrite, nonatomic) BOOL bouncesHorizontally;
         @property (assign, readwrite, nonatomic) UIStatusBarStyle menuPreferredStatusBarStyle;
         @property (assign, readwrite, nonatomic) BOOL menuPrefersStatusBarHidden;
         */
        
        //self.scaleMenuView = false
        self.scaleContentView = false
        self.menuPreferredStatusBarStyle = .default
        self.menuPrefersStatusBarHidden = true
        self.contentViewShadowEnabled = true
        self.contentViewShadowColor = UIColor.darkGray
        self.contentViewShadowOpacity = 0.5
    }
    
    
}//Class End.
