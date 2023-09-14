//
//  SignUpRequest.swift
//  FOAV
//
//  Created by hoon Kim on 16/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import Foundation

// SignUp = /auth/join
// login = /auth/login
// confirm

struct LoginRequest: Codable {
    var loginId: String
    var password: String
    enum CodingKeys: String, CodingKey {
        case loginId = "loginId"
        case password = "password"
    }
}

struct KakaoJoinRequest: Codable {
    var loginId: String
    var password: String
    var name: String
    var birth: String
    var tel: String
    var gender: String
    
    enum CodingKeys: String, CodingKey{
        case loginId = "loginId"
        case password = "password"
        case name = "name"
        case birth = "birth"
        case tel = "tel"
        case gender = "gender"
    }
}

struct KakaoCheckId: Codable {
    let loginId: String
    
    enum CodingKeys: String, CodingKey {
        case loginId = "loginId"
    }
}

struct CheckloginId: Codable {
    var loginId: String
    
    enum CodingKeys: String, CodingKey {
        case loginId = "loginId"
    }
}

struct sendPhoneCodeRequest: Codable {
    var email: String
    var joinOrFind: String
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case joinOrFind = "diff"
    }
}

struct FindMyIdRequest: Codable {
    var email: String
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
    }
}

struct CheckphoneCodeRequest: Codable {
    var code: String
    var codeHash: String
    var requestTime: String
    
    enum CodingKeys: String, CodingKey {
        case code = "confirm"
        case codeHash = "confirmHash"
        case requestTime = "effectiveTime"
    }
}

struct ChangePasswordRequest: Codable {
    var loginId: String
    var password: String
    var email: String
    
    enum CodingKeys: String, CodingKey {
        case loginId = "loginId"
        case password = "password"
        case email = "email"
    }
    
}

struct SignUpRequest: Codable {
    var loginId: String?
    var password: String?
    var name: String?
    var birth: String?
    var tel: String?
    var gender: String?
    var email: String?
    
    enum CodingKeys: String, CodingKey{
        case loginId = "loginId"
        case password = "password"
        case name = "name"
        case birth = "birth"
        case tel = "tel"
        case gender = "gender"
        case email = "email"
    }
    
    init(
        loginId: String? = nil,
        password: String? = nil,
        name: String? = nil,
        birth: String? = nil,
        tel: String? = nil,
        gender: String? = nil,
        email: String? = nil
        
    ) {
        self.loginId = loginId
        self.password = password
        self.name = name
        self.birth = birth
        self.tel = tel
        self.gender = gender
        self.email = email
    }
}

