//
//  VersionApi.swift
//  FOAV
//
//  Created by hoon Kim on 20/11/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import Foundation
import Alamofire

// 서버랑 통신하는 api 만드는 곳
enum VersionApi: ApiRouter {
    case checkVersion
   
    
    
    var method: HTTPMethod{
        switch self{
    case .checkVersion:
            
            return .get
            
        }
    }
    
    var path: String{
        switch self{
        case .checkVersion : return "/version"
        }
    }
    
    func urlRequest() throws -> URLRequest {
        
        let url = try baseUrl.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .checkVersion :
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        }
        return urlRequest
    }
    
    #if DEBUG
    var fakeFile: String? {
        return nil
    }
    #endif
}

