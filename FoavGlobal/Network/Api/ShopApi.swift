//
//  ShopApi.swift
//  FOAV
//
//  Created by hoonKim on 2021/08/15.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import Foundation
import Alamofire

var id_ShopApi: Int = 0

enum ShopApi: ApiRouter {
  
  case shopRegist(param: ShopRegistRequest)
  case shopUpdate(param: ShopRegistRequest)
  case shopRemove(id: Int)
  
  case shopFileRegist
  case shopImageRegist
  case shopImageRemove(id: Int)
  
  case shopList(param: ShopListRequest)
  case shopDetail(id: Int)
  
  case shopReviewRegist(param: ShopReviewRegistRequest)
  case shopReviewUpdate(comment: String)
  case shopReviewImageRegist
  case shopReviewList(shopId: Int)
  
  var method: HTTPMethod{
    switch self{
      case .shopList,
           .shopDetail,
           .shopReviewList:
        return .get
      case .shopRegist,
           .shopFileRegist,
           .shopImageRegist,
           .shopReviewRegist,
           .shopReviewImageRegist:
        return .post
      case .shopUpdate,
           .shopReviewUpdate:
        return .put
      case .shopImageRemove,
           .shopRemove:
        return .delete
    }
  }
  
  var path: String {
    switch self {
      
      case .shopRegist : return "/shop/register"
      case .shopUpdate: return "/shop/update?id=\(id_ShopApi)"
      case .shopRemove: return "/shop/remove"
        
      case .shopFileRegist : return "/shop/file/register?shopId=\(id_ShopApi)"
      case .shopImageRegist: return "/shopImage/register?shopId=\(id_ShopApi)"
      case .shopImageRemove: return "/shopImage/remove"
        
      case .shopList : return "/shop/list"
      case .shopDetail : return "/shop/detail"
        
      case .shopReviewList: return "/shopReview/list"
      case .shopReviewRegist: return "/shopReview/register"
      case .shopReviewUpdate: return "/shopReview/update?id=\(id_ShopApi)"
      case .shopReviewImageRegist: return "/shopReviewImage/register?shopReviewId=\(id_ShopApi)"
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
      case .shopRegist(let param):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .shopUpdate(let param):
        urlRequest = try URLEncoding.default.encode(urlRequest2, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .shopRemove(let id):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["id": id])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .shopFileRegist:
        urlRequest = try URLEncoding.default.encode(urlRequest2, with: nil)
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .shopImageRegist:
        urlRequest = try URLEncoding.default.encode(urlRequest2, with: nil)
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .shopImageRemove(let id):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["id": id])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        
        
      case .shopList(let param):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .shopDetail(let id) :
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["id": id])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        
      case .shopReviewList(let shopId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["shopId": shopId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        
      case .shopReviewRegist(let param) :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .shopReviewUpdate(let comment):
        urlRequest = try URLEncoding.default.encode(urlRequest2, with: ["comment": comment])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .shopReviewImageRegist:
        urlRequest = try URLEncoding.default.encode(urlRequest2, with: nil)
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



