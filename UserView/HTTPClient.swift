//
//  HTTPClient.swift
//  Popcorn
//
//  Created by Sam Clewclo on 2/6/17.
//  Copyright © 2017 SamClewlow. All rights reserved.
//

import UIKit

class HTTPClient {
    
    let kHTTPErrorDomain = "HTTPErrorDomain"
    
    enum DataResult {
        case success(Any)
        case failure(Error)
    }
    
    typealias HTTPDataRequestCompletion = (DataResult) -> Void
    
    fileprivate var sessions: [ParserFactory.ParserType: URLSession] = [:]
    
    // Singleton 
    static let sharedInstance = HTTPClient()
    private init() {}
    
    /// Perfomrs a get request for the speciefed response type
    ///
    /// - Parameters:
    ///   - url: The URL string that locates the resource
    ///   - responseType: The expected resource type
    ///   - completion: A completion block to be called once the request finishes
    /// - Returns: The inflight data task
    func getRequestFor(url urlString: String,
                       responseType: ParserFactory.ParserType,
                       completion: @escaping HTTPDataRequestCompletion) -> URLSessionDataTask? {
    
        
        guard let url = URL(string: urlString) else {
            // Call completion failure
            completion(.failure(getErrorToReturn(error: nil)))
            return nil
        }
        
        let parser = ParserFactory().getParserFor(parserType: responseType)
        let session = getSessionFor(parser: parser)
        
        var mutableRequest = URLRequest(url: url)
        mutableRequest.httpMethod = "GET"
        
        // Trigger request
        let responseHandler = handleResponseBlock(parser: parser, completion: completion)
        let requestDataTask = session.dataTask(with: mutableRequest,
                                               completionHandler: responseHandler)
        
        
        requestDataTask.resume()
        return requestDataTask
    }
    
    
    // MARK:- Helpers
    
    fileprivate func getSessionFor(parser: Parser) -> URLSession {
        
        // If we have a session for this type, return it
        if let session = sessions[parser.type] {
            return session
        }
        
        // We need to create a new one
        let config = URLSessionConfiguration.default
        if let contentType = parser.acceptContentType() {
            config.httpAdditionalHeaders = ["Accept": contentType]
        }
        
        
        let session = URLSession(configuration: config,
                                 delegate: nil, 
                                 delegateQueue: OperationQueue.main)
        
        // Store the session
        sessions[parser.type] = session
        
        return session
        
    }
    
    fileprivate func getErrorToReturn(error: Error?) -> Error {
        
        // If the error exists, we can return it
        if let error = error {
            return error
        } else {
            // Return a generic error
            return NSError(domain: kHTTPErrorDomain,
                           code: 0,
                           userInfo: [NSLocalizedDescriptionKey:"Something went wrong"])
        }
    }
    
    fileprivate func handleResponseBlock(parser: Parser,
                                         completion: @escaping HTTPDataRequestCompletion) -> (Data?, URLResponse?, Error?) -> Void {
        return { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            // Check if we have data, otherwise fail
            guard let data = data else {
                completion(.failure(self.getErrorToReturn(error: error)))
                return
            }
            
            // Parse the data
            let parsedObject: Any
            do {
                parsedObject = try parser.parseDataToObject(data: data)
            } catch (let error) {
                completion(.failure(error))
                return
            }
            
            completion(.success(parsedObject))
        }
    }
}
