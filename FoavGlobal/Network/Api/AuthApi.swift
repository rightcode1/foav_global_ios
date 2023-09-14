//
//  AuthApi.swift
//  FOAV
//
//  Created by hoon Kim on 16/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import Foundation
import Alamofire 

// 서버랑 통신하는 api 만드는 곳
enum AuthApi: ApiRouter {
    case SignUp(param: SignUpRequest)
    case login(param: LoginRequest)
    case sendCode(param: sendPhoneCodeRequest)
    case checkId(id: CheckloginId)
    case confirm(param: CheckphoneCodeRequest)
    case visit
    case privacy
    case kakaoCheckId(param: KakaoCheckId)
    case kakaoJoin(param: KakaoJoinRequest)
    case findId(param: FindMyIdRequest)
    case changePassword(param: ChangePasswordRequest)
    var method: HTTPMethod{
        switch self{
        case
        .SignUp,
        .login,
        .confirm,
        .sendCode,
        .changePassword,
        .kakaoJoin:
            return .post
        case .kakaoCheckId,
             .checkId,
             .visit,
             .findId,
             .privacy:
            
            return .get
            
        }
    }
    
    var path: String{
        switch self{
        case .kakaoCheckId : return "/auth/existSNS"
        case .kakaoJoin : return "/auth/join/kakao"
        case .SignUp : return "/auth/join/global/normal"
        case .login : return "/auth/login"
        case .sendCode : return "/auth/mail"
        case .checkId : return "/auth/checkRedundancy"
        case .confirm : return "/auth/confirm"
        case .visit : return "admin/visitors"
        case .privacy  : return "auth/privacy"
        case .changePassword : return "/auth/changePassword"
        case .findId : return "/auth/findUser"
        }
    }
    
    func urlRequest() throws -> URLRequest {
        
        let url = try baseUrl.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .kakaoCheckId(let param) :
            urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        case .kakaoJoin(let param) :
            urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        case .SignUp(let param) :
            urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        case .login(let param) :
            urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        case .sendCode(let param) :
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: makeParams(param))
            urlRequest.addValue("\(token)", forHTTPHeaderField: "Authorization")
        case .checkId(let param) :
            urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        case .confirm(let param) :
            urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        case .visit :
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .privacy :
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .changePassword(let param) :
            urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        case .findId(let param) :
            urlRequest = try URLEncoding.default.encode(urlRequest, with: makeParams(param))
        }
        return urlRequest
    }
    
    #if DEBUG
    var fakeFile: String? {
        return nil
    }
    #endif
}
