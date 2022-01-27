//
//  NetworkHandler.swift
//  GS-APOD
//
//  Created by Rahul Chaudhary on 26/01/22.
//

import Foundation

/// This enum will contain environment related info (baseURL) e.g dev, stagging, qa, live...
fileprivate enum Environment: String {
    case live = "https://api.nasa.gov"
}

/// This enum will contain endpoint related info.
fileprivate enum Endpoint: String {
    case apod = "/planetary/apod"
}

/// This enum will contain HTTP(s) method info.
enum RequestMethod: String {
    case get = "GET"
}

class NetworkHandler {
    
    static let shared = NetworkHandler()
    private var environment: Environment = .live
    private var api_key = "fzOOXLCWfbZNornC6XOmhaaVGkhGAgI8tybXVGeq"

    private init() {}

    //MARK: -
    
    /// Return array of 'URLQueryItem' from params 'dict'
    /// - Parameter dict: dict is params 'Dictionary<String, String>'
    /// - Returns: Array for 'URLQueryItem' e.g [URLQueryItem]
    private func queryItemsFromParams(dict: [String: String]) -> [URLQueryItem] {
        return dict.map { (key: String, value: String) in
            return URLQueryItem.init(name: key, value: value)
        }
    }
    
    /// Pre populate common params in each API
    /// - Returns: Dictionary for params
    private func prePopulateParams() -> [String: String] {
        return ["api_key": api_key]
    }
    
    /// Make REST API call
    /// - Parameters:
    ///   - url: REST url
    ///   - method: HTTP(s) method
    ///   - headers: request header in 'Dictionary<String, String>' format or nil
    ///   - body: request body in 'Data' format or nil
    ///   - cachePolicy: cachePolicy, default is 'returnCacheDataElseLoad'
    ///   - completion: callback closure
    private func sendRequest(url: URL, method: RequestMethod, headers: [String: String]? = nil, body: Data? = nil, cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {

        var urlRequest = URLRequest(url: url, cachePolicy: cachePolicy)
        urlRequest.httpMethod = method.rawValue
        
        if let headers = headers {
            urlRequest.allHTTPHeaderFields = headers
        }
        if let body = body {
            urlRequest.httpBody = body
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                completion(data, response, error)
            }
        }
        task.resume()
    }
    
    //MARK: - Get APOD
    
    /// Retrieve APOD image
    /// - Parameter dateString: The date of the APOD image to retrieve
    /// - Parameter completion: callback closure
    func getAPOD(dateString: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        var param = prePopulateParams()
        param["date"] = dateString //YYYY-MM-DD
        param["thumbs"] = "True" //Return the URL of video thumbnail. If an APOD is not a video, this parameter is ignored.
                
        var urlComponent = URLComponents(string: environment.rawValue+Endpoint.apod.rawValue)
        urlComponent?.queryItems = queryItemsFromParams(dict: param)
        
        guard let url = urlComponent?.url else {
            completion(nil, nil, nil)
            return
        }
        sendRequest(url: url, method: .get, completion: completion)
    }
}
