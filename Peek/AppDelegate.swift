//
//  AppDelegate.swift
//  Peek
//
//  Created by Garret Koontz on 1/21/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let darkColor = UIColor(red: 66/255, green: 64/255, blue: 64/255, alpha: 1.0)
        UINavigationBar.appearance().barTintColor = darkColor
        UINavigationBar.appearance().tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Avenir Next", size: 20)!]
        UITabBar.appearance().barTintColor = darkColor
        UITabBar.appearance().tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        UIApplication.shared.statusBarStyle = .lightContent
        
        //MARK: - NSUserDefaults to store if user has accepted Terms and Conditions
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let rootViewController = UserDefaults.standard.bool(forKey: "termsAccepted") ? storyboard.instantiateViewController(withIdentifier: "mainVC") : storyboard.instantiateViewController(withIdentifier: "termsVC")
        
        window?.rootViewController = rootViewController
        
        return true
    }
}

