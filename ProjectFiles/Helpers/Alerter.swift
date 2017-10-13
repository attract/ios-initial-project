//
//  Alerter.swift
//  
//
//  Created by Stanislav Makushov on 12/10/2017.
//  Copyright © 2017 Stanislav Makushov. All rights reserved.
//

import Foundation
import BulletinBoard

class Alerter: NSObject {
    class func success(title: String, description: String, image: UIImage? = nil, continueAction: (() -> Void)?) -> BulletinManager {
        
        let bulletinManager: BulletinManager = {
            
            let rootItem = PageBulletinItem(title: title)
            rootItem.descriptionText = description
            rootItem.actionButtonTitle = "Continue".localized
            rootItem.isDismissable = true
            
            rootItem.interfaceFactory.tintColor = Constants.UI.Popup.Color.success
            rootItem.interfaceFactory.actionButtonTitleColor = .white
            rootItem.shouldCompactDescriptionText = true
            
            rootItem.image = image == nil ? Constants.UI.Popup.Image.success : image
            
            rootItem.actionHandler = { item in
                item.manager?.dismissBulletin(animated: true)
                if let action = continueAction {
                    action()
                }
            }
            
            return BulletinManager(rootItem: rootItem)
        }()
        
        return bulletinManager
    }
    
    class func error(title: String, description: String, image: UIImage? = nil, retryAction: (() -> Void)?) -> BulletinManager {
        let bulletinManager: BulletinManager = {
            
            let rootItem = PageBulletinItem(title: title)
            rootItem.descriptionText = description
            rootItem.isDismissable = true
            
            rootItem.interfaceFactory.tintColor = Constants.UI.Popup.Color.error
            rootItem.interfaceFactory.actionButtonTitleColor = .white
            rootItem.shouldCompactDescriptionText = true
            
            rootItem.image = image == nil ? Constants.UI.Popup.Image.error : image
            
            if let action = retryAction {
                rootItem.actionButtonTitle = "Retry".localized
                rootItem.actionHandler = { item in
                    item.manager?.dismissBulletin(animated: true)
                    action()
                }
                
                rootItem.alternativeButtonTitle = "Cancel".localized
                rootItem.alternativeHandler = { item in
                    item.manager?.dismissBulletin(animated: true)
                    // do nothing
                }
            } else {
                rootItem.actionButtonTitle = "Close".localized
                rootItem.actionHandler = { item in
                    item.manager?.dismissBulletin(animated: true)
                    // do nothing
                }
            }
            
            return BulletinManager(rootItem: rootItem)
        }()
        
        return bulletinManager
    }
    
    class func warning(title: String, description: String, image: UIImage? = nil, continueAction: (() -> Void)?) -> BulletinManager {
        
        let bulletinManager: BulletinManager = {
            
            let rootItem = PageBulletinItem(title: title)
            rootItem.descriptionText = description
            rootItem.actionButtonTitle = "OK".localized
            rootItem.isDismissable = true
            
            rootItem.interfaceFactory.tintColor = Constants.UI.Popup.Color.warning
            rootItem.interfaceFactory.actionButtonTitleColor = .white
            rootItem.shouldCompactDescriptionText = true
            
            rootItem.image = image == nil ? Constants.UI.Popup.Image.warning : image
            
            rootItem.actionHandler = { item in
                item.manager?.dismissBulletin(animated: true)
                if let action = continueAction {
                    action()
                }
            }
            
            return BulletinManager(rootItem: rootItem)
        }()
        
        return bulletinManager
    }
    
    class func custom(title: String, description: String, mainActionTitle: String, mainAction: (() -> Void)?, secondaryActionTitle: String? = nil, secondaryAction: (()->Void)? = nil, icon: UIImage? = nil, color: UIColor? = nil) -> BulletinManager {
        
        let bulletinManager: BulletinManager = {
            
            let rootItem = PageBulletinItem(title: title)
            rootItem.descriptionText = description
            
            if let tintColor = color {
                rootItem.interfaceFactory.tintColor = tintColor
                rootItem.interfaceFactory.actionButtonTitleColor = .white
            }
            
            if let icon = icon {
                rootItem.image = icon
            }
            
            rootItem.actionButtonTitle = mainActionTitle
            rootItem.alternativeButtonTitle = secondaryActionTitle
            rootItem.shouldCompactDescriptionText = true
            
            rootItem.isDismissable = true
            
            rootItem.actionHandler = { item in
                item.manager?.dismissBulletin(animated: true)
                if let mainAction = mainAction {
                    mainAction()
                }
            }
            
            if let alternativeAction = secondaryAction {
                rootItem.alternativeHandler = { item in
                    item.manager?.dismissBulletin(animated: true)
                    alternativeAction()
                }
            }
            
            return BulletinManager(rootItem: rootItem)
        }()
        
        return bulletinManager
    }
    
    class func confirm(title: String, description: String, color: UIColor? = nil, image: UIImage? = nil, actionTitle: String, action: @escaping() -> Void) -> BulletinManager {
        let bulletinManager: BulletinManager = {
            
            let rootItem = PageBulletinItem(title: title)
            rootItem.descriptionText = description
            rootItem.isDismissable = true
            
            if let tintColor = color {
                rootItem.interfaceFactory.tintColor = tintColor
                rootItem.interfaceFactory.actionButtonTitleColor = .white
            }
            rootItem.shouldCompactDescriptionText = true
            
            rootItem.image = image
            
            rootItem.actionButtonTitle = actionTitle
            rootItem.actionHandler = { item in
                item.manager?.dismissBulletin(animated: true)
                action()
            }
            
            rootItem.alternativeButtonTitle = "Cancel".localized
            rootItem.alternativeHandler = { item in
                item.manager?.dismissBulletin(animated: true)
                // do nothing
            }
            
            return BulletinManager(rootItem: rootItem)
        }()
        
        return bulletinManager
    }
    
    class func info(title: String = "", description: String, image: UIImage? = nil) -> BulletinManager {
        let bulletinManager: BulletinManager = {
            
            let rootItem = PageBulletinItem(title: title)
            rootItem.descriptionText = description
            rootItem.isDismissable = true
            
            rootItem.image = image
            
            rootItem.shouldCompactDescriptionText = true
            
            return BulletinManager(rootItem: rootItem)
        }()
        
        return bulletinManager
    }
}
