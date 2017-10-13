//
//  ReachabilityManager.swift
//  
//
//  Created by Stanislav Makushov on 11.07.17.
//  Copyright © 2017 Stanislav Makushov. All rights reserved.
//

import Foundation
import ReachabilitySwift

class ReachabilityManager: NSObject {
    
    let reachability = Reachability()!
    
    func reachableOperations(backgroundOperations: @escaping ()->(), mainOperations: @escaping ()->()) {
        reachability.whenReachable = { reachability in
            backgroundOperations()
            DispatchQueue.main.async {
                mainOperations()
            }
        }
    }
    
    func unReachableOperations(backgroundOperations: @escaping ()->(), mainOperations: @escaping ()->()) {
        reachability.whenUnreachable = { reachability in
            backgroundOperations()
            DispatchQueue.main.async {
                mainOperations()
            }
        }
    }
    
    func beginObserving(delegate: UIViewController) {
        NotificationCenter.default.addObserver(delegate, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do {
            try reachability.startNotifier()
            print("Start observing")
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {
            
        } else {
            
        }
    }
    
    func stopObserving(delegate: UIViewController) {
        reachability.stopNotifier()
        print("Stop observing")
        NotificationCenter.default.removeObserver(delegate, name: ReachabilityChangedNotification, object: reachability)
    }
}
