//
//  CarbonLivingApi.swift
//  FOAV
//
//  Created by hoonKim on 2021/01/25.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import Foundation
import Alamofire

var userChallengeId: Int = 0

var updateIdWithApi: Int = 0

enum PointSaveDiff: String, Codable {
  case 자동차
  case 지자체
  case 태양광
}

enum CarbonLivingApi: ApiRouter {
  case carbonInfo
  
  case activityList
  case carbonCompanyList
  case carbonCompanyDetail(id: Int)
  case challengeList(param: ChallengeListRequest)
  case employeesChallengeList(param: ChallengeListRequest)
  case carbonLivingList
  case carbonLivingDetail(id: Int)
  
  case carbonSaveStoreList(latitude: String, longitude: String)
  
  case challengeDetail(id: Int)
  case challengeUserList(param: ChallengeUserListRequest)
  case challengeUserRankList(param: ChallengeUserRankListRequest)
  case challengeUserDetail(id: Int)
  case challengeUserRemove(id: Int)
  case challengeUserUpdate(content: String)
  
  case challengeUserRegistWish(challengeUserId: Int)
  case challengeUserRemoveWish(challengeUserId: Int)
  
  case challengeUserCommentList(challengeUserId: Int)
  
  case challengeUserCommentRegist(content: String, challengeUserId: Int)
  case challengeUserCommentModify(content: String)
  case challengeUserCommentRemove(commentId: Int)
  
  case challengeUserCommentRegistWish(challengeUserCommentId: Int)
  case challengeUserCommentRemoveWish(challengeUserCommentId: Int)
  
  case registChallenge(challengeId: Int, content: String)
  case registChallengeImage
  case removeChallengeImage(id: Int)
  
  case registUserChallengeLike(challengeUserId: Int)
  case removeUserChallengeLike(challengeUserId: Int)
  
  case registCarbonPoint(param: RegistCarbonPointRequest)
  case registCarbonPointImage(carbonPointHistoryId: Int)
  
  case registPointSave(diff: PointSaveDiff)
  case registPointSaveImage(pointSaveId: Int)
  
  case carbonPointHistoryList(date: String)
  
  var method: HTTPMethod{
    switch self{
      case  .carbonInfo,
            .activityList,
            .carbonCompanyList,
            .carbonCompanyDetail,
            .challengeList,
            .carbonSaveStoreList,
            .employeesChallengeList,
            .challengeDetail,
            .challengeUserList,
            .challengeUserDetail,
            .challengeUserRankList,
            .challengeUserCommentList,
            .carbonLivingList,
            .carbonLivingDetail,
            .registCarbonPoint,
            .carbonPointHistoryList:
        return .get
        
      case .registChallenge,
           .registChallengeImage,
           .registPointSave,
           .registPointSaveImage,
           .registUserChallengeLike,
           .registCarbonPointImage,
           .challengeUserCommentRegist,
           .challengeUserRegistWish,
           .challengeUserCommentRegistWish:
        return .post
      case .challengeUserUpdate,
           .challengeUserCommentModify:
        return .put
      case .challengeUserRemove,
           .removeChallengeImage,
           .removeUserChallengeLike,
           .challengeUserCommentRemove,
           .challengeUserCommentRemoveWish,
           .challengeUserRemoveWish:
        return .delete
        
        
    }
  }
  
  var path: String {
    switch self {
      
      case .carbonInfo: return "/carbon/detail"
      case .activityList: return "/activity/list"
      case .carbonCompanyList: return "/companyIntroduction/list"
      case .carbonCompanyDetail: return "/companyIntroduction/detail"
      case .challengeList: return "/challenge/list"
      case .employeesChallengeList: return "/challenge/list"
      case .carbonLivingList: return "/carbonLiving/list"
      case .carbonLivingDetail: return "/carbonLiving/detail"
        
      case .carbonSaveStoreList: return "/carbonSaveStore/list"
        
      case .challengeDetail: return "/challenge/detail"
      case .challengeUserList: return "/challengeUser/list"
      case .challengeUserDetail: return "/challengeUser/detail"
      case .challengeUserRemove: return "/challengeUser/remove"
      case .challengeUserUpdate: return "/challengeUser/update"
      case .challengeUserRankList: return "/challengeUser/rank"
      case .challengeUserRegistWish: return "/challengeUserLike/register"
      case .challengeUserRemoveWish: return "/challengeUserLike/remove"
        
      case .challengeUserCommentList: return "/challengeUserComment/list"
      
      case .challengeUserCommentRegist: return "/challengeUserComment/register"
      case .challengeUserCommentModify: return "/challengeUserComment/update?id=\(updateIdWithApi)"
      case .challengeUserCommentRemove: return "/challengeUserComment/remove"
      
      case .challengeUserCommentRegistWish: return "/challengeUserCommentWish/register"
      case .challengeUserCommentRemoveWish: return "/challengeUserCommentWish/remove"
        
      case .registChallenge: return "/challengeUser/register"
      case .registChallengeImage: return "/challengeUserImage/register"
      case .removeChallengeImage: return "/challengeUserImage/remove"
      case .registUserChallengeLike: return "/challengeUserLike/register"
      case .removeUserChallengeLike: return "/challengeUserLike/remove"
        
      case .registCarbonPoint: return "/carbonPointHistory/register"
      case .registCarbonPointImage: return "/carbonPointHistoryImage/register"
        
      case .registPointSave: return "/pointSave/register"
      case .registPointSaveImage: return "/pointSaveImage/register"
        
      case .carbonPointHistoryList: return "/carbonPointHistory/list"
        
    }
  }
  
  func urlRequest() throws -> URLRequest {
    
    let url = try baseUrl.asURL()
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    urlRequest.httpMethod = method.rawValue
    
    
    let urlStr: String = "\(ApiEnvironment.baseUrl)/challengeUser/update?id=\(userChallengeId)"
    let encoded  = urlStr.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
    var urlRequest2 = URLRequest(url: URL(string: encoded!)!)
    urlRequest2.httpMethod = method.rawValue
    
    let urlStr3: String = "\(ApiEnvironment.baseUrl)/challengeUserImage/register?challengeUserId=\(userChallengeId)"
    let encoded3  = urlStr3.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
    var urlRequest3 = URLRequest(url: URL(string: encoded3!)!)
    urlRequest3.httpMethod = method.rawValue
    
    let modifyUrlStr: String = "\(ApiEnvironment.baseUrl)\(path)"
    let encoded4  = modifyUrlStr.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
    var urlRequest4 = URLRequest(url: URL(string: encoded4!)!)
    urlRequest4.httpMethod = method.rawValue
    
    switch self {
      case .carbonInfo:
        urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .activityList:
        urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .carbonCompanyList:
        urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .carbonCompanyDetail(let id):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["id": id])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .challengeList(let param):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .employeesChallengeList(let param):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .carbonLivingList:
        urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .carbonLivingDetail(let id):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["id": id])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .carbonSaveStoreList(let latitude, let longitude):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: ["latitude": latitude, "longitude": longitude])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .challengeDetail(let id):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["id": id])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .challengeUserList(let param):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .challengeUserDetail(let id):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["id": id])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .challengeUserRemove(let id):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["id": id])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .challengeUserUpdate(let content):
        urlRequest = try URLEncoding.default.encode(urlRequest2, with: ["content": content])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .challengeUserRankList(let param):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .challengeUserRegistWish(let challengeUserId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["challengeUserId": challengeUserId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .challengeUserRemoveWish(let challengeUserId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["challengeUserId": challengeUserId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        
      case .challengeUserCommentList(let challengeUserId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["challengeUserId": challengeUserId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .challengeUserCommentRegist(let content, let challengeUserId):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: ["content": content, "challengeUserId": challengeUserId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .challengeUserCommentModify(let content):
        urlRequest = try URLEncoding.default.encode(urlRequest4, with: ["content": content])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .challengeUserCommentRemove(let commentId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["id": commentId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .challengeUserCommentRegistWish(let challengeUserCommentId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["challengeUserCommentId": challengeUserCommentId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .challengeUserCommentRemoveWish(let challengeUserCommentId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["challengeUserCommentId": challengeUserCommentId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        
      case .registChallenge(let challengeId, let content):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: ["challengeId": challengeId, "content": content])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .registChallengeImage:
        urlRequest = try URLEncoding.default.encode(urlRequest3, with: nil)
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .removeChallengeImage(let id):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["id": id])
      case .registUserChallengeLike(let challengeUserId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["challengeUserId": challengeUserId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .removeUserChallengeLike(let challengeUserId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["challengeUserId": challengeUserId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .registCarbonPoint(let param):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .registCarbonPointImage(let carbonPointHistoryId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["carbonPointHistoryId": carbonPointHistoryId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .registPointSave(let diff):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: ["diff": diff])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .registPointSaveImage(let pointSaveId):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["pointSaveId": pointSaveId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .carbonPointHistoryList(let date):
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["date": date])
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

