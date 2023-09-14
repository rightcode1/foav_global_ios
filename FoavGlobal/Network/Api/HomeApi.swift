//
//  HomeApi.swift
//  FOAV
//
//  Created by hoon Kim on 30/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import Foundation
import Alamofire


enum HomeApi: ApiRouter {
  
  case getYoutubeCode
  case getAdvertisement(param: AdvertisementRequest)
    case getetabAdvertisement
  case getPopupImage(location: String)
  case clickCount
  case foavNews
  case homeData
  case getPopup(diff: String)
  
  var method: HTTPMethod{
    switch self{
      case
      .getYoutubeCode,
      .getAdvertisement,
      .getPopupImage,
      .clickCount,
      .getetabAdvertisement,
      .foavNews,
      .homeData,
      .getPopup:
        return .get
      
    }
  }
  
  var path: String{
    switch self{
      case .getYoutubeCode : return "/mainVideo"
      case .getAdvertisement : return "/advertisement/view"
    case .getetabAdvertisement : return "/advertisement/view"
      case .getPopupImage : return "/advertisement/view"
      case .foavNews : return "/news/mainList"
      case .clickCount : return "/advertisement/\(clickToAdvertisementId)/clickCount"
      case .homeData : return "/home"
      case .getPopup : return "/advertise/detail"
    }
  }
  
  func urlRequest() throws -> URLRequest {
    
    let url = try baseUrl.asURL()
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    urlRequest.httpMethod = method.rawValue
    
    switch self {
      case .getYoutubeCode:
        urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
      //            urlRequest.addValue(" \(token)", forHTTPHeaderField: "Authorization")
      case .getAdvertisement(let param):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        case .getetabAdvertisement:
      urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["location" : "english"])
      case .getPopupImage(let location):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["location" : location])
      case .clickCount:
        urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
      case .foavNews:
        urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
      case .homeData:
        urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
      case .getPopup(let diff):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: ["diff" : diff])
    }
    
    return urlRequest
  }
  
  #if DEBUG
  var fakeFile: String? {
    return nil
  }
  #endif
}
