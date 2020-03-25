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
  func requestSucceed(response responseData: [Any])
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
    if let url: String = urlParams["url"] as? String {
      urlBuilder = RestUrl(api: url)
    } else {
        let error: NSError = NSError()
       self.responseHandler?.requestFailed(statusCode: (error as NSError).code, description: "Url params missing")
    }
    print("coming here \(String(describing: urlBuilder?.api))")
    if let restUrl: URL = urlBuilder?.url as? URL {
      let session = URLSession(configuration: SessionConfig.config(), delegate: self, delegateQueue: nil)
      let task = session.dataTask(with: restUrl, completionHandler: { data, response, error in
        if error != nil {
          self.responseHandler?.requestFailed(statusCode: (error! as NSError).code, description: error.debugDescription)
        } else {
          if let res = data {
            let players = self.parseJsonData(data: res)
            print("name is  \(players[0].name)")
            self.responseHandler?.requestSucceed(response: players)
          }
        }
      })
      task.resume()
    }
  }
  
  
  func parseJsonData(data: Data) -> [Player] {
    
      var players = [Player]()
      do {
          let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
          let gamers = jsonResult?["data"] as! [AnyObject]
          for gamer in gamers {
            let player = Player()
            player.id = gamer["id"] as? String
            player.age = gamer["employee_age"] as? String
            player.name = gamer["employee_name"] as? String
            player.salary = gamer["employee_salary"] as? String
            player.image = gamer["profile_image"] as? String
            players.append(player)
          }
      } catch {
        print("error is \(error.localizedDescription)")
      }
      return players
  }
  
  //  Desctructor
  deinit {
  }
  
}
