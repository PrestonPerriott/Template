//
//  CompletionHelper.swift
//  Template
//
//  Created by Preston Perriott on 9/24/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import Foundation
import RealmSwift

///Typealias for block
typealias CompletionHelper<T> = ((CompletionResults<T>) -> Void)

/// Basic network result
struct CompletionResults<Val> {
    
    /// TODO: Creare error class
    var error: NSError?
    var result: Val?
}
