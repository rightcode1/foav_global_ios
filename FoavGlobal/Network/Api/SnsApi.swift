//
//  SnsApi.swift
//  FOAV
//
//  Created by hoonKim on 2020/08/26.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import Foundation
import Alamofire

// 서버랑 통신하는 api 만드는 곳
enum SnsApi: ApiRouter {
  
  case snsList(param: SnsListRequest)
  case snsDetail(boardId: Int)
  
  case snsRegister(param: SnsRegistRequest)
  case updateSns(param: SnsRegistRequest)
  case snsRemover(boardId: Int)
  
  case snsImageRegister(boardId: Int)
  case snsImageRemover(imageId: Int)
  
  case snsWishRegister(boardId: Int)
  case snsWishRemover(boardId: Int)
  
  case snsCommentList(boardId: Int)
  case snsCommentRegister(boardId: Int, content: String)
  case updateSnsComment(content: String)
  case removeComment(commentId: Int)
  case commentWishRegister(commentId: Int)
  case commentWishRemover(commentId: Int)
  
  var method: HTTPMethod{
    switch self{
      case .snsList,
           .snsDetail,
           .snsCommentList:
        return .get
      case .snsRegister,
           .snsImageRegister,
           .snsWishRegister,
           .snsCommentRegister,
           .commentWishRegister:
        return .post
      
      case .updateSnsComment,
           .updateSns:
        return .put
      case .removeComment,
           .snsWishRemover,
           .snsImageRemover,
           .snsRemover,
           .commentWishRemover:
        return .delete
    }
  }
  
  var path: String{
    switch self{
      case .snsList : return "/board/list"
      case .snsDetail : return "/board/detail"
      
      case .snsRegister: return "/board/register"
      case .updateSns: return "/board/update"
      case .snsRemover: return "/board/remove"
      
      case .snsImageRegister: return "/boardImage/register"
      case .snsImageRemover: return "/boardImage/remove"
      
      case .snsWishRegister: return "/boardWish/register"
      case .snsWishRemover: return "/boardWish/remove"
      
      
      case .snsCommentList: return "/boardComment/list"
      case .snsCommentRegister: return "/boardComment/register"
      case .updateSnsComment: return "/boardComment/update"
      case .removeComment: return "/boardComment/remove"
      case .commentWishRegister: return "/boardCommentWish/register"
      case .commentWishRemover: return "/boardCommentWish/remove"
    }
  }
  
  func urlRequest() throws -> URLRequest {
    
    let url = try baseUrl.asURL()
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    
    urlRequest.httpMethod = method.rawValue
    
    let urlStr: String = "\(ApiEnvironment.baseUrl)/boardComment/update?id=\(updateCommentId)"
    let encoded  = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    var updateCommentRequest = URLRequest(url: URL(string: encoded!)!)
    
    updateCommentRequest.httpMethod = method.rawValue
    
    let urlStr2: String = "\(ApiEnvironment.baseUrl)/board/update?id=\(updateSnsId)"
    let encoded2  = urlStr2.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    var updateSnsRequest = URLRequest(url: URL(string: encoded2!)!)
    
    updateSnsRequest.httpMethod = method.rawValue
    
    switch self {
      case .snsList(let param) :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .snsDetail(let boardId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["id": boardId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      
      case .snsRegister(let param):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .updateSns(let param):
        urlRequest = try URLEncoding.default.encode(updateSnsRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .snsRemover(let boardId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["id": boardId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      
      case .snsImageRegister(let boardId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["boardId": boardId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .snsImageRemover(let imageId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["id": imageId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      
      case .snsWishRegister(let boardId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["boardId": boardId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      
      case .snsWishRemover(let boardId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["boardId": boardId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .snsCommentList(let boardId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["boardId": boardId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .snsCommentRegister(let boardId, let content):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: ["boardId": boardId, "content" : content])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .updateSnsComment(let content):
        urlRequest = try URLEncoding.default.encode(updateCommentRequest, with: ["content": content])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .removeComment(let commentId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["id": commentId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .commentWishRegister(let commentId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["boardCommentId": commentId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .commentWishRemover(let commentId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["boardCommentId": commentId])
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
