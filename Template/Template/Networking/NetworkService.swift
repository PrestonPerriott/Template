//
//  NetworkService.swift
//  Template
//
//  Created by Preston Perriott on 10/8/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

///Note how we attempt to abstract things out to the smallest possible func

import Foundation
import Alamofire
import RealmSwift
import SwiftyJSON

private let base = Bundle.main.infoDictionary?["node_api_endpoint"]

enum EndPoints: String {
    case resgister = "/register"
    case login = "/login"
    case refresh = "/refresh"
}

/// Object has to adhere to Decodable
class NetworkService<T: Decodable> {
    
    private var decodable: T.Type
    
    private var error: NSError?
    /// Our closure thats called with completion
    private var compltetionHandler: NetworkCompletion<T>?
    
    ///Create instance of the Service
    ///The type being what were trying to decode
    init(_ type: T.Type) {
        decodable = type
    }
    
    ///Performs request and parses object
    ///Must adhere to Encodable
    public func request<Val: Encodable>(method: HTTPMethod = .get, path: EndPoints, object: Val, complete: @escaping NetworkCompletion<T>) {
        
        ///If we have paramters, given or recieved
        guard let params = try? object.toDict() else {
            complete(NetworkResults(err: NSError(domain: "Invalid Request Attempt", code: 3000, userInfo: nil), res: nil))

            return
        }
        ///pass params to request that builds params or nil
        return request(method: method, path: path, params: params, complete: complete)
    }
    
    ///Public allows same access as open but more restrictive w/ subclassing & overriding
    ///Actual funtion that fires Alamo Request
    public func request(method: HTTPMethod = .get, path: EndPoints, params: Parameters? = nil, complete: @escaping NetworkCompletion<T>) {
        
        guard let url = NetworkService.buildURL(path) else {
            complete(NetworkResults(err: NSError(domain: "Invalid Request", code: 3000, userInfo: nil), res: nil))
            return
        }
        
        compltetionHandler = complete
        ///TODO: HEADERS
        
        /// https://stackoverflow.com/questions/39571812/extra-argument-method-in-call
        Alamofire.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: nil).validate().responseData(completionHandler: handleSuccess)
        
        
    }
}

extension NetworkService {
    ///Internal allows access from any source file in the defining model but not outside
    
    ///build URL on path
    internal class func buildURL(_ path: EndPoints) -> URL? {
        return URL(string: "\(String(describing: base))\(path.rawValue)")
    }
    
    internal class func buildHeaders() -> HTTPHeaders {
        let headers = ["" : ""]
        return headers
    }
    
    ///Private allows access only from enclosing declaration & any extension in the same source file
    ///Func allows us to abstract out the success/fail logic needed in Alamo Req
    private func handleSuccess(response: DataResponse<Data>) {
        switch response.result {
        case .success(let val):
            print("Sucess with val : \(val)")
        case .failure(let err):
            print("Failed with error: \(err)")
        }
    }
    
    ///Accompaying functions for the sucess & failure of the Handler
    
}
