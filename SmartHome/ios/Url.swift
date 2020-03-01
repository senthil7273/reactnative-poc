//
//  Url.swift
//  SmartHome
//
//  Created by Senthil Murugan on 27/02/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation


enum SchemeType: String {
    case http = "http"
    case https = "https"
    case bluetooth = "bluetooth"
    case wifi = "wifi"
    case tcp = "tcp"
}

protocol Url {
  var scheme: String {set get}
  var host: String {set get}
  var path: String {set get}
}

// structure to construct custom complex url if any
struct RestUrl: Url {
  
  var scheme: String
  var host: String
  var path: String
  
  /// returns the rest url, this can be customised based on query complex
  var url: Any? {
    get {
      let apiUrl: String? = scheme+"://" + host + path
      if let urlStr = apiUrl {
          if let url = URL(string: urlStr) {
              return url
            }
          }
        return nil
      }
  }
}

// struct to construct complex url for wifi comm
  struct WifiUrl: Url {
    var scheme: String
    var host: String
    var path: String
    var port: String { get{return ""}}
}

// struct to construct complex url for bluetooth comm
  struct BluetoothUrl: Url {
    var scheme: String
    var host: String
    var path: String
    var port: String {
      get {return ""}
      set {}
      
    }
    var macAddress: String {
      get {
        return ""}
      
    }
}
