//
//  SnsV2CommentApi.swift
//  FOAV
//
//  Created by hoonKim on 2021/08/18.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import Foundation
import Alamofire

var id_SnsV2CommentApi: Int = 0

// 서버랑 통신하는 api 만드는 곳
enum SnsV2CommentApi: ApiRouter {
  case snsV2CommentList(snsId: Int)
  case registsnsV2Comment(param: RegistSnsV2CommentRequest)
  
  case removesnsV2Comment(id: Int)
  
  
  
  var method: HTTPMethod{
    switch self{
      case .snsV2CommentList:
        return .get
      case .registsnsV2Comment:
        return .post
      case .removesnsV2Comment:
        return .delete
    }
  }
  
  var path: String{
    switch self{
      case .snsV2CommentList: return "/snsComment/list"
      
      case .registsnsV2Comment: return "/snsComment/register"
      case .removesnsV2Comment: return "/snsComment/remove"
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
      case .snsV2CommentList(let snsId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["snsId": snsId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        
      case .registsnsV2Comment(let param):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")

      case .removesnsV2Comment(let id):
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
