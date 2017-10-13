//
//  ParseModel.swift
//  
//
//  Created by Stanislav Makushov on 11.07.17.
//  Copyright © 2017 Stanislav Makushov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ParseModel {
    let code: Int
    var warnings: [Warnings]
    var data: Dictionary<String,AnyObject>?
    var authError: Bool = false
    
    init(json: JSON) {
        let successCodes = [200, 201, 203, 204]
        
        let jsonResult = json.dictionaryObject as [String:AnyObject]?
        
        data = jsonResult?["data"] as? Dictionary<String, AnyObject>
        
        code = jsonResult?["status_code"] as? Int ?? 0
        warnings = []
        
        guard successCodes.contains(code) else {
            if let error = jsonResult?["error"] as? [String:AnyObject] {
                warnings = self.parseErrors(from: error)
            }
            
            return
        }
    }
    
    func parseErrors(from json:[String:AnyObject]) -> [Warnings] {
        var warnings: [Warnings] = []
        
        if let message = json["message"] as? String {
            let warning = Warnings(title: "Error".localized, meaning: message)
            
            warnings.append(warning)
        } else if let messageDict = json["message"] as? [String:AnyObject], let errors = messageDict["errors"] as? [String:AnyObject] {
            
            for (_, meaning) in errors {
                var descr = ""
                
                if meaning is String {
                    descr = meaning as! String
                } else if meaning is [String] {
                    descr = (meaning as! [String]).first!
                } else if meaning is [[String:AnyObject]], let current = (meaning as! [[String:AnyObject]]).first {
                    descr = current["message"] as? String ?? ""
                }
                
                let warning = Warnings(title: "Error".localized, meaning: descr)
                
                warnings.append(warning)
            }
        }
        
        return warnings
    }
}
