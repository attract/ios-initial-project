//
//  TapticEngine.swift
//  
//
//  Created by Stanislav Makushov on 12/10/2017.
//  Copyright © 2017 Stanislav Makushov. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

class TapticEngine: NSObject {
    public enum TapticType {
        case success
        case error
        case warning
        case custom
    }
    
    var isPhone6S: Bool {
        return UIDevice.current.modelName == "iPhone 6s" || UIDevice.current.modelName == "iPhone 6s Plus"
    }
    
    static let shared = TapticEngine()
    
    func makeTapticFeedback(_ type: TapticEngine.TapticType = .success) {
        if isPhone6S {
            var soundId: UInt32 = 1519
            
            if type == .error {
                soundId = 1521
            } else if type == .warning {
                soundId = 1520
            }
            
            AudioServicesPlaySystemSound(soundId)
        } else {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            
            var notificationType: UINotificationFeedbackType = .success
            
            if type == .error {
                notificationType = .error
            } else if type == .warning {
                notificationType = .warning
            }
            
            generator.notificationOccurred(notificationType)
        }
    }
}
