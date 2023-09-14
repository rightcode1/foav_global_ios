//
//  UserApi.swift
//  FOAV
//
//  Created by hoon Kim on 17/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//


import Foundation
import Alamofire


enum UserApi: ApiRouter {
  
  case updateUserInfo(param: UpdateUserInfoRequest)
  case userInfo
  case userHistory
  case userWithdrawal
  case userServicePerformance
  case changeUserEmail(param: ChangeUserEmailRequest)
  case registDevice(param: RegistDeviceRequest)
  case userCardCheck
  case userCard
  case userProfilePhoto
  
  case companyInfo(id: Int)
    case companySubInfo(id: Int)
  
  case registStepsCount(param: RegistStepsCountRequest)
  case workOfDayList(startDate: String, endDate: String)
  
  case regist1365
  case remove1365
  
  var method: HTTPMethod{
    switch self{
      case
        .updateUserInfo,
        .changeUserEmail,
        .userProfilePhoto,
        .registStepsCount,
        .regist1365:
        return .post
      case .userInfo,
           .userHistory,
           .userServicePerformance,
           .registDevice,
           .userCard,
           .userCardCheck,
           .companyInfo,
           .companySubInfo,
           .workOfDayList,
           .remove1365:
        return .get
      case .userWithdrawal:
        return .delete
        
    }
  }
  
  var path: String{
    switch self{
      case .userServicePerformance : return "/user/service"
      case .updateUserInfo : return "/user/update"
      case .userInfo : return "/user/info"
      case .changeUserEmail : return "/user/update"
      case .userHistory : return "/user/history"
      case .userWithdrawal : return "/user/withdrawal"
      case .registDevice : return "/device/register"
      case .userCardCheck : return "/user/cardCheck"
      case .userCard : return "/user/card"
      case .userProfilePhoto : return "/user/profile"
      case .registStepsCount : return "/step/register"
    case .companySubInfo: return "/companySub/list"
      case .companyInfo: return "/company/detail"
      case .workOfDayList: return "/user/step"
      case .regist1365: return "/user/1365"
      case .remove1365: return "/user/1365/remove"
    }
  }
  //    var request = URLRequest(url: URL(string: usersDataPoint)!)
  //    request.addValue("Token \(tokenString)", forHTTPHeaderField: "Authorization")
  func urlRequest() throws -> URLRequest {
    
    let url = try baseUrl.asURL()
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    urlRequest.httpMethod = method.rawValue
    
    switch self {
      case .updateUserInfo(let param) :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        // 헤더값을 넣어주는 것
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .userInfo :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .userHistory :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .changeUserEmail(let param) :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .registDevice(let param) :
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .userWithdrawal :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .userServicePerformance :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .userCardCheck :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
    case .companySubInfo(let id):
      urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["companyId": id])
      urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .userCard :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .userProfilePhoto :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .registStepsCount(let param):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .companyInfo(let id):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["id": id])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .workOfDayList(let startDate, let endDate):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["startDate": startDate, "endDate": endDate])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .regist1365:
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: nil)
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .remove1365:
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

