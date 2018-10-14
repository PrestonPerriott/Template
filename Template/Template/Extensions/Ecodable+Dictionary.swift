//
//  Ecodable+Dictionary.swift
//  Template
//
//  Created by Preston Perriott on 10/10/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import Foundation

/// Attempts to coerce decodable response to a dict
extension Encodable {
    
    func toDict() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dict = try
            JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                throw NSError(domain: "Invalid Data Provided", code: 1000, userInfo: nil)
        }
        return dict
    }
}
