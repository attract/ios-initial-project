//
//  RequestManager.swift
//  
//
//  Created by Stanislav Makushov on 11.07.17.
//  Copyright © 2017 Stanislav Makushov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RequestManager: NSObject {
    
    private static var Manager: Alamofire.SessionManager = {
        
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            Constants.backend.server.serverName : .disableEvaluation
        ]
        
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        
        return manager
    }()
    
    static let sharedManager = RequestManager()
    
    public enum SocialProvider: String {
        case facebook = "facebook"
        case twitter = "twitter"
    }
    
    //Main method
    func makeRequest(with params: Dictionary <String, AnyObject>?, url: String, method: HTTPMethod, completion: @escaping (_ completion: Constants.application.ResultCompletion) -> Void) {
        
        var tokenUrl = url
        // MARK: uncomment if there is user authorization in app, then change it to needed condition
        
//        if let apiToken = User.shared().token {
//            if apiToken.characters.count > 0 {
//                if tokenUrl.contains("?") {
//                    tokenUrl.append("&api_token=\(apiToken)")
//                } else {
//                    tokenUrl.append("?api_token=\(apiToken)")
//                }
//            }
//        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            "X-Requested-With" : "XMLHttpRequest",
            "cache-control": "no-cache"
        ]
        
        RequestManager.Manager.request(tokenUrl, method: method, parameters: params, headers: headers).responseJSON { response in
            if let _ = response.response {
                switch response.result {
                case .success(let jsonValue):
                    let json = JSON(jsonValue)
                    let parseManager = ParserManager()
                    let parseModel = parseManager.parseJSON(json: json)
                    let responseErrors = parseModel.warnings.isEmpty ? nil : parseModel.warnings
                    let result = Constants.application.ResultCompletion(responseErrors: responseErrors, responseError: nil, responseCode: parseModel.code, responseData: parseModel.data, authError: parseModel.authError)
                    completion(result)
                case .failure(let errorResponse):
                    if let data = response.data {
                        print(String(data: data, encoding: String.Encoding.utf8) as String!)
                    }
                    
                    let result = Constants.application.ResultCompletion(responseErrors: nil, responseError: errorResponse, responseCode: nil, responseData: nil, authError: false)
                    completion(result)
                }
            } else {
                let result = Constants.application.ResultCompletion(responseErrors: nil, responseError: response.error, responseCode: nil, responseData: nil, authError: false)
                completion(result)
            }
        }
    }
    
    func makeUploadRequest(with params: Dictionary <String, AnyObject>?, andFiles files: [UIImage], withFileName filename: String, url: String, method: HTTPMethod, completion: @escaping (_ completion: Constants.application.ResultCompletion) -> Void) {
        
        var tokenUrl = url
        // MARK: uncomment if there is user authorization in app, then change it to needed condition
        
//        if let apiToken = User.shared().token {
//            if apiToken.characters.count > 0 {
//                if tokenUrl.contains("?") {
//                    tokenUrl.append("&api_token=\(apiToken)")
//                } else {
//                    tokenUrl.append("?api_token=\(apiToken)")
//                }
//            }
//        }
        
        RequestManager.Manager.upload(
            multipartFormData: { multipartFormData in
                if files.count == 1 {
                    let imageData = UIImageJPEGRepresentation(files.first!, 0.5)
                    multipartFormData.append(imageData!, withName: filename, fileName: "photo.jpg", mimeType: "image/jpeg")
                } else {
                    for photo in files {
                        let imageData = UIImageJPEGRepresentation(photo, 0.5)
                        multipartFormData.append(imageData!, withName: filename, fileName: "photo\(String(describing: files.index(of: photo))).jpg", mimeType: "image/jpeg")
                    }
                }
                
                if let parameters = params {
                    for (key, value) in parameters {
                        multipartFormData.append(String(describing: value).data(using: .utf8)!, withName: key)
                    }
                }
        },
            to: tokenUrl,
            headers: ["X-Requested-With": "XMLHttpRequest"],
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result {
                        case .success(let jsonValue):
                            let json = JSON(jsonValue)
                            let parseManager = ParserManager()
                            let parseModel = parseManager.parseJSON(json: json)
                            let responseErrors = parseModel.warnings.isEmpty ? nil : parseModel.warnings
                            let result = Constants.application.ResultCompletion(responseErrors: responseErrors, responseError: nil, responseCode: parseModel.code, responseData: parseModel.data, authError: parseModel.authError)
                            completion(result)
                        case .failure(let errorResponse):
                            let result = Constants.application.ResultCompletion(responseErrors: nil, responseError: errorResponse, responseCode: nil, responseData: nil, authError: false)
                            completion(result)
                        }
                    }
                case .failure(let encodingError):
                    let result = Constants.application.ResultCompletion(responseErrors: nil, responseError: encodingError, responseCode: nil, responseData: nil, authError: false)
                    completion(result)
                }
        })
    }
}
