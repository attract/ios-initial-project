//
//  Constants.swift
//  
//
//  Created by Stanislav Makushov on 11.07.17.
//  Copyright © 2017 Stanislav Makushov. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

struct Constants {
    
    struct backend {
        struct server {
            static let serverProtocol   = application.environment == .development ? "http" : "https"
            static let serverName       = application.environment == .development ? "" : ""
            static let serverPath       = backend.server.serverProtocol + "://" + backend.server.serverName
            static let apiPath          = backend.server.serverPath + ""
            static let apiVersion       = ""
            static let fullApiPath      = backend.server.apiPath + backend.server.apiVersion
        }
        
        struct apiRequests {
            static let api_example_method         = "api_method"
        }
       
        struct requestExpands {
            
        }
        
        struct fieldNames {
            static let api_example_field_name      = "api_field_name"
        }
    }
    
    struct application {
        public enum Environment {
            case development
            case production
        }
        
        struct ValidCompletion {
            var result: Bool
            var resultTag: Int
        }
        
        struct ResultCompletion {
            var responseErrors: [Warnings]?
            var responseError: Error?
            var responseCode: Int?
            var responseData: Dictionary <String, AnyObject>?
            var authError: Bool = false
        }
        
        static let environment: application.Environment = .development
        
        static let currentLocalization = Bundle.main.localizations.first!
    }
    
    struct UI {
        
        struct identifiers {
            static let tableViewCellExampleId = "exampleCellId"
        }
        
        struct tags {
            static let firstNameRow = 1
            static let lastNameRow = 2
            static let emailRow = 3
            static let passwordRow = 4
            static let uniRow = 5
            static let forgotRow = 6
            static let buttonRow = 7
            static let logoutRow = 8
            static let avatarRow = 9
            static let textRow = 10
            static let loginButtonRow = 11
        }
        
        struct Color {
            
        }
        
        struct Popup {
            struct Color {
                static let success = UIColor.green
                static let error = UIColor.red
                static let warning = UIColor.yellow
            }
            
            struct Image {
                static let success = UIImage()
                static let error = UIImage()
                static let warning = UIImage()
            }
        }
    }
    
    public enum ErrorType: String {
        case noConnection = "errNoInternetConnection"
        case responseError = "errResponseError"
    }
}
