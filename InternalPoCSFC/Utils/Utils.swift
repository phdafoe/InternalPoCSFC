//
//  Utils.swift
//  InternalPoCSFC
//
//  Created by TECDATA ENGINEERING on 24/3/22.
//

import Foundation

class Utils{
    
    
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
