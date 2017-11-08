//
//  BasicTableViewController.swift
//  iClub
//
//  Created by Stanislav Makushov on 18/10/2017.
//  Copyright © 2017 Stanislav Makushov. All rights reserved.
//

import UIKit
import Reachability
import BulletinBoard

class BasicTableViewController: UITableViewController {
    
    let reachabilityManager = ReachabilityManager()
    let reachability = Reachability()!
    
    var isLoadingMore: Bool = false
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    lazy var bulletinManager: BulletinManager = {
        
        let rootItem = PageBulletinItem(title: "title")
        return BulletinManager(rootItem: rootItem)
    }()
    
    func loadMoreItems() {
        // should be overriden
    }
    
    var shouldLoadMore: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func beginConnectObserving(vc: BasicViewController) {
        NotificationCenter.default.addObserver(vc, selector: #selector(vc.reachabilityChanged),name: Notification.Name.reachabilityChanged, object:reachability)
        do {
            try reachability.startNotifier()
            print("Start observing")
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func stopConnectObserving(vc: UIViewController) {
        reachabilityManager.stopObserving(delegate: self)
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.connection != .none {
            print("Reachable")
        } else {
            print("Unreachable")
        }
    }
    
    func showAuthScreen() {
        let storyboardName = "Auth"
        
        if let vc = UIStoryboard(name: storyboardName, bundle: nil).instantiateInitialViewController() {
            UIApplication.shared.keyWindow?.rootViewController = vc
        }
    }
    
    @objc   func logout() {
        User.shared().cleanInfo()
        self.showAuthScreen()
    }
    
    func showMainScreen() {
        let storyboardName = "Main"
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        if let vc = storyboard.instantiateInitialViewController() {
            UIApplication.shared.keyWindow?.rootViewController = vc
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    func addParallaxHeader(view: UIView) {
        self.tableView.parallaxHeader.view = view
        self.tableView.parallaxHeader.height = Constants.UI.parallaxHeader.maximumHeight
        self.tableView.parallaxHeader.minimumHeight = Constants.UI.parallaxHeader.minimumHeight
        self.tableView.parallaxHeader.mode = .fill
    }
}

// MARK: BasicControllerDelegate

extension BasicTableViewController: BasicControllerDelegate {
    func showErrorScreen(withType type: Constants.ErrorType, text: String? = nil, andRefreshAction action: @escaping () -> Void) {
        let errorText: String = text == nil ? (type == .noConnection ? "NoConnection".localized : "RequestError".localized) : text!
        
        self.showError(title: "Error".localized, description: errorText, retryAction: action)
    }
    
    func updateTokenAndRepeatQuery(action: @escaping () -> Void) {
        if self.reachability.connection != .none {
            // update oauth token
        } else {
            self.showErrorScreen(withType: .noConnection, andRefreshAction: {
                self.updateTokenAndRepeatQuery(action: action)
            })
        }
    }
    
    func handleErrors(with completion: Constants.application.ResultCompletion, andRefreshAction action: @escaping () -> Void) {
        guard completion.authError == false else {
            self.updateTokenAndRepeatQuery(action: action)
            return
        }
        
        guard completion.responseCode != 401 else {
            let errorMessage = completion.responseErrors?.first?.meaning ?? "NeedLogin".localized
            
            self.showWarning(title: "Error".localized, description: errorMessage, continueAction: {
                self.logout()
            })
            
            return
        }
        
        guard completion.responseCode != 403 else {
            if let error = completion.responseErrors?.first {
                self.showErrorScreen(withType: .responseError, text: error.meaning, andRefreshAction: action)
            } else {
                self.showErrorScreen(withType: .responseError, text: "UnknownError".localized, andRefreshAction: action)
            }
            
            return
        }
        
        guard completion.responseCode != 404 else {
            self.showErrorScreen(withType: .responseError, andRefreshAction: action)
            return
        }
        
        guard completion.responseCode != 400 else {
            let warning = completion.responseErrors!.first
            self.showWarning(title: warning!.title, description: warning!.meaning, continueAction: nil)
            return
        }
        
        guard completion.responseCode != 500 else {
            self.showErrorScreen(withType: .responseError, andRefreshAction: action)
            return
        }
        
        guard completion.responseError == nil else {
            print(completion.responseError!.localizedDescription)
            self.showErrorScreen(withType: .responseError, andRefreshAction: action)
            return
        }
        
        guard completion.responseCode != 422 else {
            var warning = Warnings(title: "Error".localized, meaning: "UnknownError".localized)
            
            if let errors = completion.responseErrors {
                for error in errors {
                    if error.meaning != "" {
                        warning.meaning = error.meaning
                        break
                    }
                }
            }
            
            self.showWarning(title: warning.title, description: warning.meaning, continueAction: nil)
            
            return
        }
        
        guard completion.responseErrors == nil else {
            let warning = completion.responseErrors!.first
            self.showErrorScreen(withType: .responseError, text: warning!.meaning, andRefreshAction: action)
            
            return
        }
    }
    
    func showAppropriateAlert(tag: Int) {
        var title = ""
        var subtitle = ""
        
        switch tag {
        case Constants.UI.tags.emailRow:
            title = "Email".localized
            subtitle = "EmailInvalid".localized
            break
        case Constants.UI.tags.passwordRow:
            title = "Password".localized
            subtitle = "PasswordInvalid".localized
            break;
        case Constants.UI.tags.firstNameRow:
            title = "FirstName".localized
            subtitle = "FirstNameInvalid".localized
            break;
        case Constants.UI.tags.lastNameRow:
            title = "LastName".localized
            subtitle = "LastNameInvalid".localized
            break;
        case Constants.UI.tags.textRow:
            title = "Text".localized
            subtitle = "TextInvalid".localized
            break;
        default:
            title = "Error".localized
            subtitle = "UnknownError".localized
        }
        
        self.showWarning(title: title, description: subtitle) {
            self.view.viewWithTag(tag)?.becomeFirstResponder()
        }
    }
}

// MARK: Alerter actions
extension BasicTableViewController {
    func showSuccess(title: String, description: String, image: UIImage? = nil, continueAction: (() -> Void)? = nil) {
        self.bulletinManager = Alerter.success(title: title, description: description, image: image, continueAction: continueAction)
        
        self.finishDisplayingBulletin(.success)
    }
    
    func showWarning(title: String, description: String, image: UIImage? = nil, continueAction: (() -> Void)? = nil) {
        self.bulletinManager = Alerter.warning(title: title, description: description, image: image, continueAction: continueAction)
        
        self.finishDisplayingBulletin(.warning)
    }
    
    func showError(title: String, description: String, image: UIImage? = nil, retryAction: (() -> Void)? = nil) {
        self.bulletinManager = Alerter.error(title: title, description: description, image: image, retryAction: retryAction)
        
        self.finishDisplayingBulletin(.error)
    }
    
    func showCustom(title: String, description: String, mainActionTitle: String, mainAction: (() -> Void)? = nil, secondaryActionTitle: String? = nil, secondaryAction: (() -> Void)? = nil, icon: UIImage? = nil, color: UIColor? = nil) {
        self.bulletinManager = Alerter.custom(title: title, description: description, mainActionTitle: mainActionTitle, mainAction: mainAction, secondaryActionTitle: secondaryActionTitle, secondaryAction: secondaryAction, icon: icon, color: color)
        
        self.finishDisplayingBulletin(.success)
    }
    
    func showConfirm(title: String, description: String, color: UIColor?, image: UIImage?, actionTitle: String, action: @escaping() -> Void) {
        self.bulletinManager = Alerter.confirm(title: title, description: description, color: color, image: image, actionTitle: actionTitle, action: action)
        
        self.finishDisplayingBulletin(.success)
    }
    
    func showInfo(title: String = "", description: String, image: UIImage? = nil) {
        self.bulletinManager = Alerter.info(title: title, description: description, image: image)
        
        self.finishDisplayingBulletin(.success)
    }
    
    fileprivate func finishDisplayingBulletin(_ type: TapticEngine.TapticType) {
        self.bulletinManager.prepare()
        
        let viewControllerToPresent = self.tabBarController == nil ? self : self.tabBarController!
        
        self.bulletinManager.presentBulletin(above: viewControllerToPresent)
        self.makeTapticFeedback(type)
    }
    
    func makeTapticFeedback(_ type: TapticEngine.TapticType) {
        TapticEngine.shared.makeTapticFeedback(type)
    }
}

// MARK: Infinite scroll
extension BasicTableViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.shouldLoadMore {
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            let deltaOffset = maximumOffset - currentOffset
            
            if deltaOffset <= 0 {
                if self.isLoadingMore == false {
                    self.createBottomView()
                    self.isLoadingMore = true
                    activityIndicator.startAnimating()
                    self.tableView.tableFooterView?.isHidden = false
                    self.loadMoreItems()
                }
            }
        }
    }
    
    func createBottomView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 60))
        self.activityIndicator.tintColor = UIColor.gray
        self.activityIndicator.center = view.center
        
        self.tableView.tableFooterView?.addSubview(view)
    }
    
    func stopBottomAnimation() {
        self.tableView.reloadData()
        self.isLoadingMore = false
        self.activityIndicator.stopAnimating()
        self.tableView.tableFooterView?.isHidden = true
    }
}

