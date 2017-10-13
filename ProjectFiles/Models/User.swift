//
//  User.swift
//  
//
//  Created by Stanislav Makushov on 28.09.2017.
//  Copyright © 2017 Stanislav Makushov. All rights reserved.
//

import Foundation

class User : NSObject, NSCoding {
    var sampleField: Any?
    // TODO: add all model fields here
    
    class func shared() -> User {
        let defaults = UserDefaults.standard
        let userObject = defaults.object(forKey: "userDict")
        
        var instance = User()
        guard userObject != nil else {
            print("No keyedArchiver with userDict")
            return instance
        }
        
        instance = NSKeyedUnarchiver.unarchiveObject(with: userObject as! Data) as! User
        return instance
    }
    
    class func isAuthenticated() -> Bool {
        return true // change it to needed condition
    }
    
    override init() {
        super.init()
    }
    
    init(from dict:[String:AnyObject]) {
        super.init()
        
        self.sampleField = dict[Constants.backend.fieldNames.api_example_field_name]
        // TODO: add all model fields here
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.sampleField = aDecoder.decodeObject(forKey: Constants.backend.fieldNames.api_example_field_name)
        // TODO: add all model fields here
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.sampleField, forKey: Constants.backend.fieldNames.api_example_field_name)
        // TODO: add all model fields here
    }
    
    func saveUser() {
        let savingUser = self
        let encodedUser = NSKeyedArchiver.archivedData(withRootObject: savingUser)
        let defaults = UserDefaults.standard
        defaults.setValue(encodedUser, forKey: "userDict")
    }
    
    func cleanInfo() {
        self.sampleField = nil
        // TODO: add all model fields here
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "userDict")
    }
    
    func createUser(with dict: Dictionary <String, AnyObject>) {
        self.sampleField = dict[Constants.backend.fieldNames.api_example_field_name]
        
        saveUser()
    }
    
    class func buildUsers(from array: [[String:AnyObject]]) -> [User] {
        var users: [User] = []
        
        for item in array {
            users.append(User(from: item))
        }
        
        return users
    }
}
