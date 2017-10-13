//
//  ProgressLoader.swift
//  
//
//  Created by Stanislav Makushov on 11.07.17.
//  Copyright © 2017 Stanislav Makushov. All rights reserved.
//

import Foundation
import SVProgressHUD

class ProgressLoader: NSObject {
    class func show(with title: String = "Loading".localized) {
        SVProgressHUD.show(withStatus: title)
        SVProgressHUD.setDefaultMaskType(.clear)
    }
    
    class func hide(withCompletion completion: @escaping SVProgressHUDDismissCompletion) {
        SVProgressHUD.dismiss(completion: completion)
    }
    
    class func hide() {
        SVProgressHUD.dismiss()
    }
}
