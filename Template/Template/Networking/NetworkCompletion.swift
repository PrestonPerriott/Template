//
//  NetworkCompletion.swift
//  Template
//
//  Created by Preston Perriott on 10/8/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import Foundation

typealias NetworkCompletion<T> = (() -> Void)

struct NetworkResults<Response> {
    
    var err: NSError?
    var res: Response?
    
    //internal computed vars
    var succeeded: Bool {
        return self.err == nil && res != nil
    }
    var failed: Bool {
        return !self.succeeded
    }
}
