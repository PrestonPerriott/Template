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
        
        NetworkService.init(User.self).request(method: .post, path: EndPoints.resgister, params: params, complete: completion)
    }
    
    class func login(password: String, email: String, completion: @escaping NetworkCompletion<User>) {
       
        let params = ["email" : email,
                      "password" : password]
     NetworkService.init(User.self).request(method: .post, path: EndPoints.login, params: params, complete: completion)
    }
    
    class func logout() {
        
    }
}
