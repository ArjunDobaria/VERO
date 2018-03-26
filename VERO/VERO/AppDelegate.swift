//
//  AppDelegate.swift
//  VERO
//
//  Created by lanet on 05/03/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isOTPVerify : Bool = false
    var isProfileSet : Bool = false
    var navBarAppereance = UINavigationBar.appearance()
    var userData : NSDictionary = NSDictionary()
    var otherData : NSDictionary = NSDictionary()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared().isEnabled = true
        
        navBarAppereance.tintColor = UIColor.white
        navBarAppereance.barTintColor = UIColor.black
        navBarAppereance.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        if UserDefaults.standard.bool(forKey: "isOTPVerify")
        {
            isOTPVerify = true
            if UserDefaults.standard.bool(forKey: "isProfileSet")
            {
                isProfileSet = true
                //tab bar
                GoToDashBord()
            }
            else{
                //ProfilePage
                GoToProfile()
            }
        }
        
        return true
    }
    
    //MARK: - set Storyboard
    func storyboard() -> UIStoryboard
    {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    //MARK: - sharedDelegate
    func sharedDelegate() -> AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func GoToProfile()
    {
        let vc: ProfileViewController = storyboard().instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        let rootNav:UINavigationController = AppDelegate().sharedDelegate().window?.rootViewController as! UINavigationController
        rootNav.pushViewController(vc, animated: false)
    }
    func GoToDashBord()
    {
        let customTabbarVc : MainTabBarViewController = self.storyboard().instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
        let rootNav : UINavigationController = self.window?.rootViewController as! UINavigationController
        rootNav.pushViewController(customTabbarVc, animated: false)
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
    
    //MARK:- Alert for warnning
    
    func myWarnningAlert(_ message : String){
        let myAlert = UIAlertController(title:"Opps...!!", message : message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler:nil)
        myAlert.addAction(okAction)
        self.window?.rootViewController?.present(myAlert, animated: true, completion: nil)
        myAlert.view.tintColor = UIColor.red
    }
    
    //MARK:- Alert for shoe information
    
    func myAlert(_ message : String){
        let myAlert = UIAlertController(title:"Success", message : message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler:nil)
        myAlert.addAction(okAction)
        self.window?.rootViewController?.present(myAlert, animated: true, completion: nil)
    }
    


}

