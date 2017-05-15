//
//  AppDelegate.swift
//  Clozr
//
//  Created by CK on 4/24/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import MapKit
import UserNotifications
import Firebase

import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isBackground:Bool?
    var deferringUpdates:Bool?
    let gcmMessageIDKey = "gcm.message_id"

    var locationManager:CLLocationManager?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        
        let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
            
            print("Received Notification: \(notification!.payload.notificationID)")
        }
        
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
            // This block gets called when the user reacts to a notification received
            let payload: OSNotificationPayload = result!.notification.payload
            
            var fullMessage = payload.body
            print("Message = \(fullMessage)")
            
            if payload.additionalData != nil {
                if payload.title != nil {
                    let messageTitle = payload.title
                    print("Message Title = \(messageTitle!)")
                }
                
                let additionalData = payload.additionalData
                if additionalData?["actionSelected"] != nil {
                    fullMessage = fullMessage! + "\nPressed ButtonID: \(additionalData!["actionSelected"])"
                }
            }
        }
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false,
                                     kOSSettingsKeyInAppLaunchURL: true]
        
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "878fa889-120e-4e5b-90d5-e56a2d83aac8",
                                        handleNotificationReceived: notificationReceivedBlock, 
                                        handleNotificationAction: notificationOpenedBlock, 
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification
        
        FIRApp.configure()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        let loggedinUser = FIRAuth.auth()?.currentUser
        if loggedinUser != nil  {
//            FIRAuth.signOut(FIRAuth.auth()!)
            if let currentLoginId = User.currentLoginUserId() {
                User.getUserFromFirebase(usrId: currentLoginId, completion: { (usr1, error) in
                    FBClient.currentFacebookUser = usr1
                    FBClient.getUsersFriends()
                    

                })
                self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "contentController")

            }else{
                window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "loginController")
            }
        }else {
            window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "loginController")
        }
        
        
        
        return true
    }
    
   

    
    func applicationWillResignActive(_ application: UIApplication) {
       
        isBackground = true;
        locationManager?.stopUpdatingLocation()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter = 10.0
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.activityType = CLActivityType.automotiveNavigation
        locationManager?.startUpdatingLocation()
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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        return handled
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = String(format: "%@", deviceToken as CVarArg).trimmingCharacters(in: CharacterSet(charactersIn: "<>")).replacingOccurrences(of: " ", with: "")
       Clozer.deviceToken = token
    }


}


extension AppDelegate {
    func customizeUIStyle() {
        
        // Customize Navigation bar items
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir", size: 16)!, NSForegroundColorAttributeName: UIColor.white], for: UIControlState.normal)
    }
}
