//
//  StoreApi.swift
//  FOAV
//
//  Created by hoon Kim on 22/12/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import Foundation
import Alamofire


enum StoreApi: ApiRouter {
    case registStroe(param: RegistStoreRequest)
    case registStroeNoneUrl(param: RegistStoreRequestNoneUrl)
    case registStroeNoneDiscount(param: RegistStoreRequestNoneDiscount)
    case registStroeNoneDiscountAndUrl(param: RegistStoreRequestNoneDiscountAndUrl)
    case registThumbnail(param: RegistStoreThumbnailRequest)
    case getStoreList(param: StoreListRequest)
    case storeListDetail(param: StoreListDetailRequest)
    // 리뷰
    case reviewRegist(param: ReviewRegistRequest)
    case reviewImageRegist(reviewId: Int)
    case reviewList(param: ReviewListRequest)
    case reviewDelete(param: ReviewDelete)

    var method: HTTPMethod{
        switch self{
        case .registStroe,
             .registStroeNoneUrl,
             .registStroeNoneDiscount,
             .registStroeNoneDiscountAndUrl,
             .registThumbnail,
             .reviewRegist,
             .reviewImageRegist:
            return .post
        case .getStoreList,
             .storeListDetail,
             .reviewList:
            return .get
        case .reviewDelete:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .registStroe : return "/store/register"
        case .registStroeNoneUrl : return "/store/register"
        case .registStroeNoneDiscount : return "/store/register"
        case .registStroeNoneDiscountAndUrl : return "/store/register"
        case .registThumbnail : return "/store/fileRegister"
        case .getStoreList : return "/store/list"
        case .storeListDetail : return "/store/detail"
        case .reviewRegist : return "/review/register"
        case .reviewList : return "/review/list"
        case .reviewDelete : return "/review/delete"
            
        case .reviewImageRegist: return "/review/fileRegister"
        }
    }
    
    func urlRequest() throws -> URLRequest {
        
        let url = try baseUrl.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .registStroe(let param) :
            urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
            urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        case .registStroeNoneUrl(let param) :
            urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
            urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        case .registStroeNoneDiscount(let param) :
            urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
            urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        case .registStroeNoneDiscountAndUrl(let param) :
            urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
            urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        case .registThumbnail(let param) :
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: makeParams(param))
            urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        case .getStoreList(let param) :
            urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
            urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        case .storeListDetail(let param) :
            urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
            urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        case .reviewRegist(let param) :
            urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
            urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        case .reviewList(let param) :
            urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
            urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        case .reviewDelete(let param) :
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: makeParams(param))
            urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        case .reviewImageRegist(let reviewId):
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["reviewId" : reviewId])
            urlRequest.addValue("\(token)", forHTTPHeaderField: "authorization")
        }
        return urlRequest
    }
    
    #if DEBUG
    var fakeFile: String? {
        return nil
    }
    #endif
}

