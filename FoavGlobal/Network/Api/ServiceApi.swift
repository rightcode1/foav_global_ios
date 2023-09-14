//
//  ServiceApi.swift
//  FOAV
//
//  Created by hoon Kim on 21/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//
import Foundation
import Alamofire

// (param: ZoneStartRequest) , (param: ZoneEndRequest)
enum ServiceApi: ApiRouter {
  
  case zoneOpen(param: ZoneOpenRequest)
  case zoneStatus(param: ZoneStatusRequest)
  case zoneClose(param: ZoneCloseRequest)
  case zoneList
  case zoneStart(param: Codable)
  case zoneEnd(param: Codable)
  case zoneHistory(param: ZoneHistoryRequest)
  case zoneCloseCheck(param: ZoneCloseCheckRequest)
  case serviceGroupList(param: ServiceGruopListRequest)
  case serviceGroupDetail(param: ServiceGruopDetailRequest)
  
  case servicePortalList(param: ServicePortalListRequest)
  
  case getServiceGuideImage
  var method: HTTPMethod{
    switch self{
      case
      .zoneOpen:
        return .post
      case .zoneStatus,
           .zoneClose,
           .zoneList,
           .zoneStart,
           .zoneEnd,
           .zoneHistory,
           .zoneCloseCheck,
           .serviceGroupList,
           .servicePortalList,
           .serviceGroupDetail,
           .getServiceGuideImage:
        return .get
      
    }
  }
  
  var path: String{
    switch self{
      case .zoneOpen : return "/zone/open"
      case .zoneStatus : return "/zone/status"
      case .zoneClose : return "/zone/close"
      case .zoneList : return "/zone"
      case .zoneStart : return "/zone/start"
      case .zoneEnd : return "/zone/end"
      case .zoneHistory : return "/zone/history"
      case .zoneCloseCheck : return "/zone/closeCheck"
      case .serviceGroupList : return "/user/serviceGroup/List"
      case .serviceGroupDetail : return "/user/serviceGroup/detail"
      
      case .servicePortalList : return "/serviceBoard/list"
      case .getServiceGuideImage : return "/serviceGuide/detail"
    }
  }
  
  func urlRequest() throws -> URLRequest {
    
    let url = try baseUrl.asURL()
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    urlRequest.httpMethod = method.rawValue
    
    switch self {
      case .zoneOpen(let param) :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .zoneStatus(let param) :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .zoneClose(let param) :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .zoneList:
        urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .zoneStart(let param) :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .zoneEnd(let param) :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .zoneHistory(let param) :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .zoneCloseCheck(let param) :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .serviceGroupList(let param) :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .serviceGroupDetail(let param) :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .servicePortalList(let param):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .getServiceGuideImage:
        urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
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
