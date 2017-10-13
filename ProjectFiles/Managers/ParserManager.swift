//
//  ParserManager.swift
//  
//
//  Created by Stanislav Makushov on 11.07.17.
//  Copyright © 2017 Stanislav Makushov. All rights reserved.
//

import Foundation
import SwiftyJSON

class ParserManager: NSObject {
    
    func parseJSON(json: JSON) -> ParseModel {
        return ParseModel.init(json: json)
    }
}
