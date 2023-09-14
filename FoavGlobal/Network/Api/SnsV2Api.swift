//
//  SnsV2Api.swift
//  FOAV
//
//  Created by hoonKim on 2021/08/16.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import Foundation
import Alamofire

var id_SnsV2Api: Int = 0

// 서버랑 통신하는 api 만드는 곳
enum SnsV2Api: ApiRouter {
  case snsV2List(param: SnsV2ListRequest)
  case registSnsV2(param: RegistSnsV2Request)
  case updateSnsV2(param: RegistSnsV2Request)
  case removeSnsV2(id: Int)
  
  case registWishSnsV2(snsId: Int)
  case removeWishSnsV2(snsId: Int)
  
  case snsV2ImageRegist(snsId: Int)
  case snsV2ImageRemove(id: Int)
  
  var method: HTTPMethod{
    switch self{
      case .snsV2List:
        return .get
      case .registSnsV2,
           .snsV2ImageRegist,
           .registWishSnsV2:
        return .post
      case .updateSnsV2:
        return .put
      case .snsV2ImageRemove,
           .removeSnsV2,
           .removeWishSnsV2:
        return .delete
    }
  }
  
  var path: String{
    switch self{
      case .snsV2List : return "/sns/list"
      case .registSnsV2: return "/sns/register"
      case .updateSnsV2: return "/sns/update?id=\(id_SnsV2Api)"
      case .removeSnsV2: return "/sns/remove"
      
      case .registWishSnsV2: return "/snsWish/register"
      case .removeWishSnsV2: return "/snsWish/remove"
        
      case .snsV2ImageRegist: return "/snsImage/register"
      case .snsV2ImageRemove: return "/snsImage/remove"
    }
  }
  
  func urlRequest() throws -> URLRequest {
     
    let url = try baseUrl.asURL()
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    urlRequest.httpMethod = method.rawValue
    
    let urlStr: String = "\(ApiEnvironment.baseUrl)\(path)"
    let encoded  = urlStr.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
    var urlRequest2 = URLRequest(url: URL(string: encoded!)!)
    urlRequest2.httpMethod = method.rawValue
    
    switch self {
      case .snsV2List(let param):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        
      case .registSnsV2(let param):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        
      case .updateSnsV2(let param):
        urlRequest = try URLEncoding.default.encode(urlRequest2, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        
      case .removeSnsV2(let id):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["id": id])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        
      case .registWishSnsV2(let snsId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["snsId": snsId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .removeWishSnsV2(let snsId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["snsId": snsId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        
      case .snsV2ImageRegist(let snsId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["snsId": snsId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .snsV2ImageRemove(let id):
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
