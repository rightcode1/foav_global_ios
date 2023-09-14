//
//  Menu.swift
//  damda
//
//  Created by hoonKim on 2020/11/23.
//

import Foundation
import Alamofire

var id_ShopMenuApi: Int = 0

enum ShopMenuApi: ApiRouter {
  
  case menuList(shopId: Int)
  case menuDetail(id: Int)
  
  case menuRegist(param: MenuRegistResquest)
  
  case menuFileRegist(shopMenuId: Int)
  case menuFileRemove(shopMenuId: Int)
  
  case menuUpdate(param: MenuRegistResquest)
  case menuRemove(id: Int)
  
  var method: HTTPMethod{
    switch self{
      case .menuList,
           .menuDetail:
        return .get
      case .menuRegist,
           .menuFileRegist:
        return .post
      case .menuFileRemove,
           .menuRemove:
        return .delete
      case .menuUpdate:
        return .put
    }
  }
  
  var path: String{
    switch self{
      case .menuList : return "/shopMenu/list"
      case .menuDetail : return "/shopMenu/detail"
        
      case .menuRegist : return "/shopMenu/register"
        
      case .menuFileRegist : return "/shopMenu/file/register"
      case .menuFileRemove : return "/shopMenu/file/remove"
        
      case .menuUpdate : return "/shopMenu/update?id=\(id_ShopMenuApi)"
      case .menuRemove : return "/shopMenu/remove"
    }
  }
  
  func urlRequest() throws -> URLRequest {
    
    let url = try baseUrl.asURL()
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    
    urlRequest.httpMethod = method.rawValue
    
    let urlStr1: String = "\(ApiEnvironment.baseUrl)\(path)"
    let encoded1  = urlStr1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    var updateMenuRequest = URLRequest(url: URL(string: encoded1!)!)
    
    updateMenuRequest.httpMethod = method.rawValue
    
    switch self {
      case .menuList(let shopId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["shopId": shopId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .menuDetail(let id):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["id": id])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .menuRegist(let param):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        
      case .menuFileRegist(let shopMenuId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["shopMenuId": shopMenuId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .menuFileRemove(let shopMenuId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["shopMenuId": shopMenuId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        
      case .menuUpdate(let param):
        urlRequest = try URLEncoding.default.encode(updateMenuRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .menuRemove(let id):
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
