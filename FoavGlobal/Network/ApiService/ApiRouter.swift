//
//  ApiRouter.swift
//  BARO
//
//  Created by ldong on 2018. 1. 26..
//  Copyright © 2018년 weplanet. All rights reserved.
//

import Foundation
import Alamofire

protocol ApiRouter: URLRequestConvertible {
  
  var baseUrl: String { get }
  var method: HTTPMethod { get }
  var path: String { get }
  
  func makeParams(_: [String : Any]?) -> [String : Any]
  func makeParams(_ params: Codable) -> [String : Any]
  
  func urlRequest() throws -> URLRequest
  func asURLRequest() throws -> URLRequest
  
  #if DEBUG
  var fakeFile: String? { get }
  #endif
}

extension ApiRouter {
  
  func asURLRequest() throws -> URLRequest {
    let request = try urlRequest()
    return request
  }
  
  var baseUrl: String {
    return ApiEnvironment.baseUrl 
  }
  
  var kakaoUrl: String {
    return "https://dapi.kakao.com"
  }
  
  private func combineDefault(params: [String : Any]?) -> [String : Any] {
    var newParams = params
    if params == nil {
      newParams = [String : Any]()
    }
    return newParams!
  }
  
  func makeParams(_ params: [String : Any]?) -> [String : Any] {
    return combineDefault(params: params)
  }
  
  func makeParams(_ params: Codable) -> [String : Any] {
    return combineDefault(params: params.dictionary)
  }

}

extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)).flatMap { $0 as? [String: Any] }
  }
}
