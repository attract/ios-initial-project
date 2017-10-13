//
//  BasicControllerDelegate.swift
//  
//
//  Created by Alex Kupchak on 23.08.17.
//  Copyright © 2017 Attract Group. All rights reserved.
//

import Foundation

protocol BasicControllerDelegate {
    func showErrorScreen(withType type: Constants.ErrorType, text: String?, andRefreshAction action: @escaping () -> Void)
    func handleErrors(with completion: Constants.application.ResultCompletion, andRefreshAction action: @escaping () -> Void)
    func showAppropriateAlert(tag: Int)
}
