//
//  CommunicationManager.swift
//  SmartHome
//
//  Created by Senthil Murugan on 27/02/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

@objc
public protocol ResponseHandler: class {
  func requestSucceed(response responseData:Data)
  func requestFailed(statusCode: Int, description: String)
}

struct SessionConfig {
  
  /// return the session configuration
  static func config() -> URLSessionConfiguration {
    let sessionConfiguration:URLSessionConfiguration = URLSessionConfiguration.default
    sessionConfiguration.timeoutIntervalForRequest = 30;
    sessionConfiguration.timeoutIntervalForResource = 60;
    sessionConfiguration.requestCachePolicy = URLRequest.CachePolicy.returnCacheDataElseLoad;
    return sessionConfiguration
  }
}

@objc class CommunicationManager: URLSession, URLSessionDelegate , URLSessionDataDelegate {
  
  @objc weak var responseHandler: ResponseHandler?
  
  override init() {
    super.init()
  }
  
  /// <#Description#>
  /// - Parameters:
  ///   - urlParams: dictionary hold k/v pairs - host, scheme, api
  ///   - auth: optional - if we ant to enable oauth from js layer
  ///   - strDescription: any description to track down
  @objc func getData(withURL urlParams:Dictionary<String, Any> , auth:String, withDescription strDescription:String) {
    
    var urlBuilder: RestUrl?
    if let host = urlParams["host"], let scheme = urlParams["scheme"], let api = urlParams["api"] {
      urlBuilder  = RestUrl(scheme: scheme as! String,
                            host: host as! String,
                            path: api as! String)
    } else {
        let error: NSError = NSError()
       self.responseHandler?.requestFailed(statusCode: (error as NSError).code, description: "Url params missing")
    }
    if let restUrl: URL = urlBuilder?.url as? URL {
      let session = URLSession(configuration: SessionConfig.config(), delegate: self, delegateQueue: nil)
      let task = session.dataTask(with: restUrl, completionHandler: { data, response, error in
        if error != nil {
          self.responseHandler?.requestFailed(statusCode: (error! as NSError).code, description: error.debugDescription)
        } else {
          if let res = data{
            self.responseHandler?.requestSucceed(response: res)
          }
        }
      })
      task.resume()
    }
  }
  
  deinit {
  }
  
}
