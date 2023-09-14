//
//  CouponApi.swift
//  FOAV
//
//  Created by hoonKim on 2021/08/16.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import Foundation
import Alamofire

// 서버랑 통신하는 api 만드는 곳
enum CouponApi: ApiRouter {
  case couponList(shopId: Int)
  case couponRegist(param: CouponRegistRequest)
  case couponRemove(id: Int)
  
  
  var method: HTTPMethod{
    switch self{
      case .couponList:
        return .get
      case .couponRegist:
        return .post
      case .couponRemove:
        return .delete
        
    }
  }
  
  var path: String{
    switch self{
      case .couponList : return "/coupon/list"
      case .couponRegist : return "/coupon/register"
      case .couponRemove : return "/coupon/remove"
    }
  }
  
  func urlRequest() throws -> URLRequest {
     
    let url = try baseUrl.asURL()
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    
    urlRequest.httpMethod = method.rawValue
    
    switch self {
      case .couponList(let shopId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["shopId": shopId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .couponRegist(let param):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .couponRemove(let id):
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
