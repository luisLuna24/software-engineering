//
//  ConnectivityHandler.swift
//  ProAgeing
//
//  Created by Luis Luna on 9/26/17.
//  Copyright © 2017 Luis Luna. All rights reserved.
//

import Foundation
import WatchConnectivity
import UIKit

class ConnectivityHandler: NSObject, WCSessionDelegate {
    var session = WCSession.default()
    
    dynamic var messages = [String]()
    
    override init() {
        super.init()
        session.delegate = self
        session.activate()
        NSLog("%@", "Paired Watch: \(session.isPaired), Watch App Installed: \(session.isWatchAppInstalled)")
        
    }
    
    // MARK: - WCSessionDelegate
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        NSLog("%@", "activationDidCompleteWith activationState:\(activationState) error:\(error)")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        NSLog("%@", "sessionDidBecomeInactive: \(session)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        NSLog("%@", "sessionDidDeactivate: \(session)")
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        NSLog("%@", "sessionWatchStateDidChange: \(session)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        NSLog("didReceiveMessage: %@", message)
        
        
            replyHandler(["date" : "\(Date())"])
    
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
            let msg = message["msg"]!
            self.messages.append("Message \(msg)")
        }
    }
    
    
    
}
