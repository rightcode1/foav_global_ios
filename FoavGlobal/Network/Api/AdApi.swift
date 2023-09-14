//
//  AdApi.swift
//  FOAV
//
//  Created by hoonKim on 2021/08/18.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import Foundation
import Alamofire

// 서버랑 통신하는 api 만드는 곳
enum AdApi: ApiRouter {
  case adList(param: AdListRequest)
  case adRegist(param: AdRegistRequest)
  case adRemove(id: Int)
  
  
  var method: HTTPMethod{
    switch self{
      case .adList:
        return .get
      case .adRegist:
        return .post
      case .adRemove:
        return .delete
        
    }
  }
  
  var path: String{
    switch self{
      case .adList : return "/regionAdvert/list"
      case .adRegist : return "/regionAdvert/register"
      case .adRemove : return "/regionAdvert/remove"
    }
  }
  
  func urlRequest() throws -> URLRequest {
     
    let url = try baseUrl.asURL()
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    
    urlRequest.httpMethod = method.rawValue
    
    switch self {
      case .adList(let param):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .adRegist(let param):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .adRemove(let id):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["id": id])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
    }
    return urlRequest
  }
  
  #if DEBUG
  var fakeFile: String? {
    return nil
  }
  #endif
}
