//
//  Notificator.swift
//  ProAgeing
//
//  Created by Luis Luna on 11/9/17.
//  Copyright © 2017 Luis Luna. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

//let center = UNUserNotificationCenter.current()
let appDelegate = UIApplication.shared.delegate as! AppDelegate

let snoozeAction = UNNotificationAction(identifier: "Snooze",
                                        title: "Snooze", options: [])
let deleteAction = UNNotificationAction(identifier: "UYLDeleteAction",
                                        title: "Delete", options: [.destructive])

class Notificator {
    
    static var isGrantedNotificationAccess:Bool = false
    
    
    static func initialize () {
       self.isGrantedNotificationAccess = appDelegate.remindersAllowed
    }
    
    static func notificateMedicine(med: Medicamento) {
        let content = UNMutableNotificationContent()
        content.title = "Es hora de tomar: "
        content.body = med.nombre + " " + med.dosis + " " + med.unidad
        
        
        // Deliver the notification in five seconds.
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
                                                        repeats: false)
        
        // Schedule the notification.
        let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
        
        print("Wil Notificate")

        
        
    }
    
    
}
