//
//  User.swift
//  
//
//  Created by Stanislav Makushov on 28.09.2017.
//  Copyright © 2017 Stanislav Makushov. All rights reserved.
//

import Foundation

class User: NSObject, Codable {
    var sampleField: String?
    // TODO: add all model fields here
    
    class func shared() -> User {
        let defaults = UserDefaults.standard
        let userObject = defaults.data(forKey: "userDict")
        
        var instance = User()
        guard userObject != nil else {
            print("No keyedArchiver with userDict")
            return instance
        }
        
        do {
            instance = try JSONDecoder().decode(User.self, from: userObject!)
        } catch let jsonError {
            print("can't decode user object: \(jsonError.localizedDescription)")
        }
        
        return instance
    }
    
    override init() {
        super.init()
    }
    
    class func isAuthenticated() -> Bool {
        return true // change it to needed condition
    }
    
    func saveUser() -> Bool {
        do {
            let data = try JSONEncoder().encode(self)
            UserDefaults.standard.set(data, forKey: "userDict")
            
            return true
        } catch {
            return false
        }
    }
    
    func cleanInfo() {
        self.sampleField = nil
        // TODO: add all model fields here
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "userDict")
    }
}
