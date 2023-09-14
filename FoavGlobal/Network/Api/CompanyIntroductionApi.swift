//
//  companyIntroductionApi.swift
//  FOAV
//
//  Created by hoonKim on 2021/01/25.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import Foundation
import Alamofire


enum CompanyIntroductionApi: ApiRouter {
    case deliveryServieDetail(storeId: Int)
    case orderRegist(param: OrderRegistRequest)
    case paymentList(date: String)
    case paymentDetail(id: Int)


    var method: HTTPMethod{
        switch self{
        case .deliveryServieDetail,
             .paymentList,
             .paymentDetail:
            return .get
        case .orderRegist:
            return .post
        }
    }
    
    var path: String {
        switch self {
        
        case .deliveryServieDetail : return "/deliveryService/detail"
        case .orderRegist : return "/order/register?deliveryServiceId=\(deliveryServiceId)"
        case .paymentList : return "/order/user/list"
        case .paymentDetail : return "/order/user/detail"
        }
    }
    
    func urlRequest() throws -> URLRequest {
        
        let url = try baseUrl.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        
      let urlStr: String = "\(ApiEnvironment.baseUrl)/order/register?deliveryServiceId=\(deliveryServiceId)"
        let encoded  = urlStr.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        var urlRequest2 = URLRequest(url: URL(string: encoded!)!)
        urlRequest2.httpMethod = method.rawValue
        
        switch self {
        case .deliveryServieDetail(let storeId) :
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["storeId": storeId])
            urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        case .orderRegist(let param):
            urlRequest = try URLEncoding(arrayEncoding: .noBrackets).encode(urlRequest2, with: makeParams(param))
            urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        case .paymentList(let date) :
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["date": date])
            urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        case .paymentDetail(let id) :
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

