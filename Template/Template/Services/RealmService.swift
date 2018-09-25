//
//  RealmService.swift
//  Template
//
//  Created by Preston Perriott on 9/24/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import Foundation
import RealmSwift

typealias DatabaseWriteBlock = (() -> Bool)

class RealmService: NSObject {
        
    static let shared = RealmService()
        
    /// Gets an instance of realm
    class func realm () throws -> Realm {
        guard let realm = try? Realm() else {
            ///TODO: Make Error class
            throw NSError(domain: "Database Initialization error", code: -600, userInfo: nil)
        }
        return realm
    }
        
    /// Writes to realm
    func write<T: Object> (_ object: T) throws {
        let realm = try RealmService.realm()
        
        do {
            try realm.write {
                realm.add(object, update: true)
            }
        } catch {
            ///TODO: Make Error class
            throw NSError(domain: "Database write error", code: -650, userInfo: nil)
        }
    }
    
    func write(block: DatabaseWriteBlock) throws {
        let realm = try RealmService.realm()
        
        do {
            realm.beginWrite()
            if (block()) == true {
                try realm.commitWrite()
            } else {
                realm.cancelWrite()
            }
        } catch {
            ///TODO: Make Error class
            throw NSError(domain: "Database write error", code: -675, userInfo: nil)
        }
    }
        
    /// Deletes database
    func erase () throws {
        let realm = try RealmService.realm()
        realm.deleteAll()
    }
}
