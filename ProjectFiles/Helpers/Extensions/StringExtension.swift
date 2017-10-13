//
//  StringExtension.swift
//  
//
//  Created by Stanislav Makushov on 11.07.17.
//  Copyright © 2017 Stanislav Makushov. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    func substring(_ r: Range<Int>) -> String {
        if self.length < r.upperBound {
            return self
        }
        
        let fromIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
        let toIndex = self.index(self.startIndex, offsetBy: r.upperBound)
        return "\(self.substring(with: Range<String.Index>(uncheckedBounds: (lower: fromIndex, upper: toIndex))))..."
    }
    
    var length: Int {
        return self.characters.count
    }
    
    var urlencoded: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    func startsWith(string: String) -> Bool {
        guard let range = range(of: string, options:[.caseInsensitive]) else {
            return false
        }
        return range.lowerBound == startIndex
    }
    
    var withoutHTMLTags: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    func getAttributedStringFromHTML(originalFont: Bool = false, fontSize: CGFloat = 15) -> NSAttributedString {
        if let data = self.data(using: .utf8) {
            do {
                let attributedString = try NSMutableAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:String.Encoding.utf8.rawValue], documentAttributes: nil)
                
                if originalFont == false {
                    let font: UIFont = UIFont.systemFont(ofSize: 15)
                    
                    attributedString.addAttributes([NSFontAttributeName:font], range: NSRange.init(location: 0, length: attributedString.length))
                }
                
                return attributedString
            } catch {
                return NSAttributedString(string: self)
            }
        } else {
            return NSAttributedString(string: self)
        }
    }
}

// concatenate attributed strings
func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString
{
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(right)
    return result
}

extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSLinkAttributeName, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}
