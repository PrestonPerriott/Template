//
//  User.swift
//  Template
//
//  Created by Preston Perriott on 9/25/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import Foundation
import RealmSwift

///TODO: create backend to logically continue
class User: Object, Codable {
    
    ///When we get a user back from the node backend
    ///These are the properties we expect
    @objc dynamic var id = ""
    @objc dynamic var username = ""
    @objc dynamic var email = ""
    @objc dynamic var accessToken = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    internal enum CodingKeys: String, CodingKey {
        case id = "id"
        case username = "username"
        case email = "email"
        case accessToken = "accessToken"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        email = try container.decode(String.self, forKey: .email)
        accessToken = try container.decode(String.self, forKey: .accessToken)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(username, forKey: .username)
        try container.encode(email, forKey: .email)
        try container.encode(accessToken, forKey: .accessToken)
    }
}
