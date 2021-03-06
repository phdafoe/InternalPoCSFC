//
//  Utils.swift
//  InternalPoCSFC
//
//  Created by TECDATA ENGINEERING on 24/3/22.
//

import Foundation
import WebKit

class Utils{
    
    static let shared = Utils()
    
    func clearCache() {
        if #available(iOS 9.0, *) {
            let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
            let date = NSDate(timeIntervalSince1970: 0)
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date as Date, completionHandler:{ })
        } else {
            var libraryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, false).first!
            libraryPath += "/Cookies"
            do {
                try FileManager.default.removeItem(atPath: libraryPath)
            } catch {
                print("error")
            }
            URLCache.shared.removeAllCachedResponses()
        }
    }
    
    struct Constants {
        // Url's PRO
        static let urlProWithData = "https://pass.carrefour.es/tarjeta/origen=MIC4&data="
        static let urlProWithoutData = "https://pass.carrefour.es/tarjeta/origen=MIC4"
        // Url's CUA
        static let urlCuaWithData = "https://bcmspassdigitalcua.global.npsa.carrefour.es/?origen=MIC4&data="
        static let urlCuaWithoutData = "https://bcmspassdigitalcua.global.npsa.carrefour.es/?origen=MIC4"
    }
    
    
}

// MARK: - Helpers
extension String {
    
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }

    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}
