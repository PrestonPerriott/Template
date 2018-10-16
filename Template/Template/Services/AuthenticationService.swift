//
//  AuthenticationService.swift
//  Template
//
//  Created by Preston Perriott on 10/12/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import Foundation

class AuthenticationService {
    
    class func register(username: String, password: String, email: String, completion: @escaping NetworkCompletion<User>) {
        ///Should chain the login function, so returning a user obj might not be necessary
        let params = ["username" : username,
                      "email" : email,
                      "password" : password]
        
        NetworkService.init(User.self).request(method: .get, path: EndPoints.resgister, params: params, complete: completion)
    }
    
    class func login(username: String, password: String, email: String, completion: @escaping NetworkCompletion<User>) {
       
        let params = ["username" : username,
                      "email" : email,
                      "password" : password]
     NetworkService.init(User.self).request(method: .get, path: EndPoints.login, params: params, complete: completion)
    }
    
    class func logout() {
        
    }
}
