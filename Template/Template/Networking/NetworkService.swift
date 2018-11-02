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
    case home = "/home"
}

/// Object has to adhere to Decodable
class NetworkService<T: Decodable> {
    
    private var decodable: T.Type
    
    private var networkServiceError: NSError?
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
        let headers = NetworkService.buildHeaders()
        
        /// https://stackoverflow.com/questions/39571812/extra-argument-method-in-call
        Alamofire.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseData(completionHandler: handleSuccess)
        
        
    }
}

extension NetworkService {
    ///Internal allows access from any source file in the defining model but not outside
    ///build URL on path
    internal class func buildURL(_ path: EndPoints) -> URL? {
        guard let base = base else {
            return URL(string: "")
        }
        return URL(string: "\(base)\(path.rawValue)")
    }
    
    internal class func buildHeaders() -> HTTPHeaders {
        var headers = ["Accept": "application/json",
                       "Content-Type": "application/json",
                       "Device": "\(UIDevice.current.model)",
                       "Version": "\(UIDevice.current.systemVersion)"]
        
        guard let user = RealmService.shared.getCurrentUser() else {
            return headers
        }
        headers["Authorization"] = user.accessToken
        print("\n******THE HEADERS ARE :  \(headers)")
        return headers
    }
    ///Private allows access only from enclosing declaration & any extension in the same source file
    ///Func allows us to abstract out the success/fail logic needed in Alamo Req
    private func handleSuccess(response: DataResponse<Data>) {
        switch response.result {
        case .success(let val):
            print("Sucess with val : \(val)")
            requestDidSucceed(val)
        case .failure(let err):
            print("Failed with error: \(err)")
            requestDidFail(response, error: err)
        }
    ///Good to note DataResponse is a struct internal to Alamofire that reps a serialized resp
    }
    
    ///Accompaying functions for the sucess & failure of the Handler
    
    /// Takes the data that we pass it
    private func requestDidSucceed(_ data: Data) {
        do {
            let resObj = try JSONDecoder().decode(T.self, from: data)
            self.compltetionHandler?(NetworkResults(err: nil, res: resObj))
        } catch {
            ///Need to make an error class 
            print("Our error trying to decode the res obj is: \(error)")
            print("The blob object looks like : \(JSON.init(data))")
            self.compltetionHandler?(NetworkResults(err: error as NSError, res: nil))
        }
    }
    
    ///Takes data from server and error from Alamofire Request
    private func requestDidFail(_ data: DataResponse<Data>, error: Error) {
        ///Sloppy attempt to see what type of error we got back
        if let res = data.response {
            networkServiceError = NSError(domain: res.description, code: res.statusCode, userInfo: nil)
            self.compltetionHandler?(NetworkResults(err: networkServiceError, res: nil))
        } else {
            
            if let alamoError = error as? Alamofire.AFError {
                networkServiceError = NSError(domain: alamoError.errorDescription ?? "Failed Getting Error Description", code: alamoError.responseCode ?? 0, userInfo: nil)
            } else {
                networkServiceError = NSError(domain: "Unknown", code: 0, userInfo: nil)
            }
        }
        self.compltetionHandler?(NetworkResults(err: networkServiceError, res: nil))
    }
}
