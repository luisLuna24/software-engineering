//
//  AppDelegate.swift
//  ProAgeing
//
//  Created by Luis Luna on 8/29/17.
//  Copyright © 2017 Luis Luna. All rights reserved.
//

import UIKit
import UserNotifications
import WatchConnectivity
import HealthKit
import SystemConfiguration
import EventKit
import UIKit



@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {
    
    public var usuario: Usuario!
    
    

    var window: UIWindow?
    let userDefaults = UserDefaults()
    var connectivityHandler: ConnectivityHandler?
    
    var calendarIdentifier = ""
    
    var remindersAllowed = false


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("USER SAVED IN DEFAULTS: \(self.userSavedInDefaults())")
        
        if WCSession.isSupported() {
            self.connectivityHandler = ConnectivityHandler()
            
            guard   let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
                
            
                let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType),
                let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
                let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
                let height = HKObjectType.quantityType(forIdentifier: .height),
                let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
                let heart = HKObjectType.quantityType(forIdentifier: .heartRate),
                
                let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
                    return false
             
            }
            
            let healthKitTypesToWrite: Set<HKSampleType> = [heart,
                                                            HKObjectType.workoutType()]
            let healthKitTypesToRead: Set<HKObjectType> = [heart,
                                                           HKObjectType.workoutType()]
            
            HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite,
                                                 read: healthKitTypesToRead) { (success, error) in
                                                    print("Autorización de acceso a salud es: \(success)")
                                                   // completion(success, error)
            }
            
            
        } else {
            NSLog("WCSession no es soportada en este dispositivo")
        }
       
        let item = UIMenuItem(title: "Editar", action: #selector(UserDetailsTableViewController.editarUser))
        
        let menu = UIMenuController.shared
        
        var newItems = menu.menuItems
            ?? [UIMenuItem]()
        newItems.append(item)
        menu.menuItems = newItems
        
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
            if granted {
                self.remindersAllowed = true
            } else {
                print(error)
            }
        }
        
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
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)

        return true
    }
    
    func userSavedInDefaults() -> Bool {
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)

        if ((self.userDefaults.object(forKey: "usuario")) != nil) {
            return true
        } else {
            return false
        }
    }
    
    func deleteUserFromDefaults() -> Bool {
      //  self.userDefaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
     // self.userDefaults.removeObject(forKey: "usuario")
        
        let dictionary = userDefaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            userDefaults.removeObject(forKey: key)
        }

      userDefaults.synchronize()
      print("USER DELETED FROM DEFAULTS")
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
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
    
    func internetConnected() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
     func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
        
    }
    
    
    
  
    

    
    
}
