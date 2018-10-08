//
//  NetworkService.swift
//  Template
//
//  Created by Preston Perriott on 10/8/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

private let base = Bundle.main.infoDictionary?["node_api_endpoint"]

enum EndPoints: String {
    case resgister = "/register"
    case login = "/login"
    case refresh = "/refresh"
}

/// Object has to Decodable
class NetworkService<T: Decodable> {
    
}
