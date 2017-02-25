//
//  GetRemoteUserInteractor.swift
//  UserView
//
//  Created by Sam Clewclo on 2/25/17.
//  Copyright © 2017 SamClewlow. All rights reserved.
//

import Foundation

class GetRemoteUserInteractor {
    
    private let baseURL = "https://randomuser.me/api/"
    private let queryString = "?results="

    // Store the request so we can cancel. Not really needed for current requirements but may be 
    // needed later if we support refreshing
    private var currentTask: URLSessionDataTask?
    
    enum Result {
        case success([User])
        case failure(NSError)
    }
    
    typealias GetUserCompletion = (Result) -> ()
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient = HTTPClient.sharedInstance) {
        self.httpClient = httpClient
    }
    
    func getRemoteUsers(numberOfUsers: Int, completion: @escaping GetUserCompletion) {
        
        // Discard any ongoing requests
        currentTask?.cancel()
        currentTask = nil
        
        // Build the URL
        let url = "\(baseURL)\(queryString)\(numberOfUsers)"
        
        // Make the request
        currentTask = HTTPClient.sharedInstance.getRequestFor(url: url, responseType: .JSON) {[weak self] result in
            
            // Drop the current task
            self?.currentTask = nil
            
            switch result {
            case .success(let JSONObject):
                
                // Create the model objects
                guard let dict = JSONObject as? [String:Any],
                    let results = dict["results"] as? [[String:Any]] else {
                        
                        // Unexpected JSON
                        completion(.failure(NSError(domain: "GetUserDomain", code: 0, userInfo: [NSLocalizedDescriptionKey:"Bad Response"])))
                        return
                }
                
                
                let users = results.map({User(JSON:$0)}).filter({$0 != nil}) as! [User]
                completion(.success(users))
                
            case .failure(let error):
                completion(.failure(error as NSError))
            }
        }
    }
}
