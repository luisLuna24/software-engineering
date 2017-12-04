//
//  AppDelegate.swift
//  ProAgeing
//
//  Created by Luis Luna on 8/29/17.
//  Copyright © 2017 Luis Luna. All rights reserved.
//

import UIKit
//import Firebase
import WatchConnectivity
import HealthKit



@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {
    
    public var usuario: Usuario!
    
    

    var window: UIWindow?
    let userDefaults = UserDefaults()
    var connectivityHandler: ConnectivityHandler?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("USER SAVED IN DEFAULTS: \(self.userSavedInDefaults())")
        if WCSession.isSupported() {
            self.connectivityHandler = ConnectivityHandler()
        } else {
            NSLog("WCSession no es soportada en este dispositivo")
        }
       
        let item = UIMenuItem(title: "Editar", action: #selector(UserDetailsTableViewController.editarUser))
        
        let menu = UIMenuController.shared
        
        var newItems = menu.menuItems
            ?? [UIMenuItem]()
        newItems.append(item)
        menu.menuItems = newItems
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        self.saveUserInDefaults()
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveUserInDefaults()
        
    }
    
    func saveUserInDefaults() -> Bool {
        if self.usuario == nil {
            print("User is still nil")
            return false
        }
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.usuario)
        userDefaults.set(encodedData, forKey: "usuario")
        userDefaults.synchronize()
        print("******DATA SAVED******")
        return true
    }
    
    func userSavedInDefaults() -> Bool {
        if ((self.userDefaults.object(forKey: "usuario")) != nil) {
            return true
        } else {
            return false
        }
    }
    
    func deleteUserFromDefaults() -> Bool {
      self.userDefaults.removeObject(forKey: "usuario")
      userDefaults.synchronize()
      print("USER DELETED FROM DEFAULTS")
        return true
    }
    
    func readUserFromDefaults() {
        if let data = UserDefaults.standard.data(forKey: "usuario"),
            let userr: Usuario? = NSKeyedUnarchiver.unarchiveObject(with: data) as! Usuario {
            print("USER FROM DEFAULTS " + (userr?.nombre)!)
            self.usuario = userr
        }
    }
    
    func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
        let healthStore = HKHealthStore()
        healthStore.handleAuthorizationForExtension { (success, error) -> Void in
            //...
        }
    }
    
    
}

extension String {
    func isEmail() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]+$", options: NSRegularExpression.Options.caseInsensitive)
            return regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.characters.count)) != nil
        } catch { return false }
    }
    
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
   
}

extension UITextField {
    
    func setBottomLine(borderColor: UIColor) {
        
        self.borderStyle = UITextBorderStyle.none
        self.backgroundColor = UIColor.clear
        
        let borderLine = UIView()
        let height = 1.0
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - height, width: Double(self.frame.width), height: height)
        
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
    }
    
}


















