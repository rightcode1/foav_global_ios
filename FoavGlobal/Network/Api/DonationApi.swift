//
//  DonationApi.swift
//  FOAV
//
//  Created by hoon Kim on 13/01/2020.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import Foundation
import Alamofire


enum DonationApi: ApiRouter {
  case donationList(param: DonationListRequest)
  case charityList(param: CharityListRequest)
    case charityDetail(id:Int)
  case paymentDonation(param: PaymentDonationRequest)
  case payCheck(param: PayCheckRequest)
  case charityHistory(date: String)
  
  case charityRank(param: CharityRankListRequest)
  
  case donation(charityId: Int)
  
  var method: HTTPMethod{
    switch self{
      case .charityList,
           .charityDetail,
           .donationList,
           .charityHistory,
           .charityRank:
        return .get
      case .paymentDonation,
           .payCheck,
           .donation:
        return .post
    }
  }
  
  var path: String {
    switch self {
      case .charityList : return "/v2/charity/list"
      case .charityDetail : return "/v2/charity/detail"
      case .charityRank : return "charityHistory/rank"
      case .donationList : return "/donation/user/list"
      case .paymentDonation : return "/donation/buyInfo"
      case .payCheck : return "/donation/buyCheck"
        
      case .charityHistory : return "/charityHistory/list"
      case .donation : return "/charityHistory/register"
    }
  }
  
  func urlRequest() throws -> URLRequest {
    
    let url = try baseUrl.asURL()
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    
    urlRequest.httpMethod = method.rawValue
    
    switch self {
      case .charityList(let param) :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .charityDetail(let chrityId) :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: ["charityId" : chrityId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .donationList(let param) :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .paymentDonation(let param) :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .payCheck(let param) :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .charityRank(let param) :
        urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
      case .donation(let chrityId):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: ["charityId" : chrityId])
        urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
      case .charityHistory(let date):
        urlRequest = try URLEncoding.default.encode(urlRequest, with: ["date" : date])
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

