//
//  UITableViewCellExtension.swift
//  
//
//  Created by Alex Kupchak on 24.05.17.
//  Copyright © 2017 Stanislav Makushov. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    
    func addSeparator(_ fullLine: Bool = false) {
        let view = UIView()
        let bounds = self.bounds
        view.backgroundColor = UITableView().separatorColor!
        let x: CGFloat = fullLine ? 0.0 : 16.0
        view.frame = CGRect(x: bounds.origin.x+x, y: bounds.size.height - 1, width: bounds.size.width, height: 1)
        self.addSubview(view)
    }
    
    func addMiddleSeparator() {
        let view = UIView()
        let bounds = self.bounds
        view.backgroundColor = UITableView().separatorColor!
        let x: CGFloat = 16.0
        view.frame = CGRect(x: bounds.origin.x+x, y: bounds.size.height - 1, width: bounds.size.width-(x*2), height: 1)
        
        self.addSubview(view)
    }
}

