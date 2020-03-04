//
//  AppDelegate.swift
//  24Hour User
//
//  Created by mac on 03/05/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import CoreLocation
import IQKeyboardManagerSwift
import FBSDKCoreKit
import GoogleSignIn
import UserNotifications

let gClientId = "151117438876-f0t3r54lj7qeib657vprqb683mqk4t17.apps.googleusercontent.com"


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var token = "iOS123"
    var userId = ""
    var userInfo = NSMutableDictionary()
    var currentLocation: CLLocation? = nil
    var locationManager = CLLocationManager()
    var userType = "patient"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        GIDSignIn.sharedInstance().clientID = gClientId
        IQKeyboardManager.shared.enable = true
        registerForPushNotification()
        requestForLocation()
        manageSession()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: SESSION
    func manageSession() {
        if let data = UserDefaults.standard.data(forKey: keyUserInfo) {
            if let dict = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSDictionary {
                print("userInfo-\(dict)-")
                userId = string(dict, "id")
                userInfo = dict.mutableCopy() as! NSMutableDictionary
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "RootView") as! RootView
                window?.rootViewController = vc
            }
        }
    }
    
    func saveUser(_ dict: NSDictionary) {
        let encodeData = NSKeyedArchiver.archivedData(withRootObject: dict)
        UserDefaults.standard.set(encodeData, forKey: keyUserInfo)
        userInfo = dict.mutableCopy() as! NSMutableDictionary
        userId = string(dict, "id")
    }
    
    func logOut() {
        userId = ""
        userInfo.removeAllObjects()
        UserDefaults.standard.removeObject(forKey: keyUserInfo)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "startNav")
        kAppDelegate.window?.rootViewController = vc
    }
    
    //MARK: REQUEST FOR LOCATION
    func requestForLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            /*let encodeData = NSKeyedArchiver.archivedData(withRootObject: currentLocation!)
            UserDefaults.standard.set(encodeData, forKey: "LastLocation")
            UserDefaults.standard.synchronize()*/
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func checkUsersLocationServicesAuthorization() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Full Access")
                return true
                
            case .notDetermined:
                requestForLocation()
                return false
                
            case .restricted, .denied:
                Http.alert("Allow Location Access", "24hDr needs access to your location. Turn on Location Services in your device settings.")
                return false
            }
        } else {
            Http.alert("Allow Location Access", "24hDr needs access to your location. Turn on Location Services in your device settings.")
            return false
        }
    }
    
    //MARK: NOTIFICATIONS
    func registerForPushNotification()  {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
                guard granted else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            })
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map{ data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        token = tokenParts.joined()
        print("deviceToken-\(token)-")
        UserDefaults.standard.set(token, forKey: "token")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("error-\(error.localizedDescription)-")
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }
    
    var obChat: ChatVC? = nil
    var obConversation: ConversationsVC? = nil
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("userInfo-\(userInfo)-")
        if let dict = userInfo["aps"] as? NSDictionary {
            
            /*if string(dict, "key") == "You have a new chat message" {
                if obChat != nil {
                    if obChat!.isBuyChat {
                        obChat?.wsRefreshBuyConversation()
                    } else {
                        obChat?.wsRefreshSellConversation()
                    }
                    
                } else if obConversation != nil {
                    obConversation?.wsRefreshConversation()
                }
            }*/
        }
    }
    
    func goToChatScreen(_ dict: NSDictionary) {
        let alert = UIAlertController(title: appName, message: string(dict, "title"), preferredStyle: .alert)
        
        let actionYes = UIAlertAction(title: "See", style: .default, handler: { action in
            
            let state = UIApplication.shared.applicationState
            /*if state == .background  || state == .inactive{
                let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBar
                vc.selectedIndex = 3
            }else if state == .active {
                let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBar
                vc.selectedIndex = 3
                self.window?.rootViewController = vc
            }*/
        })
        
        let actionCancel = UIAlertAction(title: "Later", style: .destructive, handler: { action in
            print("action cancel handler")
        })
        
        alert.addAction(actionYes)
        alert.addAction(actionCancel)
        
        DispatchQueue.main.async {
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: FACEBOOK, GOOGLE
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

//        if url.absoluteString.contains("263916010954280") {
            let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
            return handled
//        }
//        else {
//            return GIDSignIn.sharedInstance().handle(url as URL?, sourceApplication: sourceApplication, annotation: annotation)
//        }
    }
    
//    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
//        return handled
//    }


}

